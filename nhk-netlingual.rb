#!/usr/bin/ruby
# このファイルはＵＴＦ－８です（テキストエディタの自動文字コード誤判定防止用文字列）
require 'rexml/document'
require 'net/https'
require 'rbconfig'
require 'pathname'
require 'fileutils'

def os()
  host_os = RbConfig::CONFIG['host_os']
  case host_os
  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
    :windows
  when /darwin|mac os/
    :macosx
  when /linux/
    :linux
  when /solaris|bsd/
    :unix
  else
    :unknown
  end
end

CONF_DIR_LINUX   = '/usr/local/etc/nhk-netlingual'
CONF_DIR_WINDOWS = File.dirname(__FILE__)
CONF_DIR = os == :linux ? CONF_DIR_LINUX : CONF_DIR_WINDOWS


def set_ext_encoding(io)
  if os() == :windows then
    io.set_encoding(Encoding::UTF_8)
  end
end

CACERT_PEM      = 'cacert.pem'
SSL_CACERT_FILE = File.expand_path(CACERT_PEM, CONF_DIR)

PROGRAM_LIST_CONF = 'program-list.conf'


XML_URL   = ['https://cgi2.nhk.or.jp/gogaku/st/xml', 'listdataflv.xml']
AUDIO_URL = ['https://nhks-vh.akamaihd.net/i/gogaku-stream/mp4', 'master.m3u8']

PROGRAM_LIST = File.expand_path(PROGRAM_LIST_CONF, CONF_DIR)


class Music
  attr_reader :title, :hdate, :kouza, :code, :file, :nendo, :pgcode

  def initialize(music)
    title_attr  = music.attribute('title')
    hdate_attr  = music.attribute('hdate')
    kouza_attr  = music.attribute('kouza')
    code_attr   = music.attribute('code')
    file_attr   = music.attribute('file')
    nendo_attr  = music.attribute('nendo')
    pgcode_attr = music.attribute('pgcode')

    @title  = title_attr ? title_attr.value : ''
    @hdate  = hdate_attr ? hdate_attr.value : ''
    @kouza  = kouza_attr ? kouza_attr.value : ''
    @code   = code_attr ? code_attr.value : ''
    @file   = file_attr ? file_attr.value : ''
    @nendo  = nendo_attr ? nendo_attr.value : ''
    @pgcode = pgcode_attr ? pgcode_attr.value : ''
  end

  def audio_url()
    return "#{AUDIO_URL[0]}/#{@file}/#{AUDIO_URL[1]}"
  end

end

def download_xml(kouza)
  endpoint = "#{XML_URL[0]}/#{kouza}/#{XML_URL[1]}"
  ret = nil
  uri = URI.parse(endpoint)
  https = Net::HTTP.new(uri.host, 443)
  https.ca_file = SSL_CACERT_FILE if os() == :windows
#$stderr.puts("CONF_DIR       : #{CONF_DIR}")
#$stderr.puts("SSL_CACERT_FILE: #{SSL_CACERT_FILE}")
  https.use_ssl = true

  res = nil
  https.start() {
    res = https.get(uri.path)
  }
  hash = nil
  if res.is_a?(Net::HTTPSuccess) then
    ret = {:xml => res.body, :http_response => res}
  else
    ret = {:xml => nil, :http_response => res}
  end
  return ret
end

def download(music, outdir)
  hash = nil
  outfname = (Pathname(outdir) / "#{music.title}_#{music.nendo}年度_#{music.hdate}.mp3").to_s
  outfname_part = "#{outfname}.part"
  if !File.exist?(outfname) then
    child_pid = Process.spawn(
      'ffmpeg',
      '-i', music.audio_url,
      '-loglevel', 'error',
      '-f', 'mp3',
      outfname_part,
      '-y'
    )
    result = Process.waitpid2(child_pid)
    puts("ffmpeg exit with #{result[1].exitstatus}.")
    if result.nil? then
      return :dl_failure
    else
      File.rename(outfname_part, outfname)
      return :dl_success
    end
  else
    return :file_exists
  end
end

def usage()

$stderr.puts("PROGRAM_LIST: #{PROGRAM_LIST}")
  program_list = ''
  File.open(PROGRAM_LIST, "r") do |f|
    set_ext_encoding(f)
    while line = f.gets() do
      program_list += line if !(line =~ /^\s*#/) && !(line =~ /^\s*$/)
    end
  end
  puts()
  puts("Usage: #{File.basename($0)} 番組パス 保存先ディレクトリ")
  puts()
  puts("  番組パス")
  program_list.each_line do |line|
    puts("    #{line}")
  end
  puts()
  puts("Copyright (c) 2019, Shimaden. Twitter: @SHIMADEN")
  puts()
end

#--- Main ---

if ARGV.size != 2 then
  usage()
  exit(1)
end

kouza  = ARGV[0]
outdir = ARGV[1]

begin
  if !FileTest.directory?(outdir) then
    FileUtils.mkdir_p(outdir)
  end
rescue SystemCallError => e
  $stderr.puts("#{e.class}: #{e.message}")
  $stderr.puts("保存先ディレクトリを作成できませんでした: #{outdir}")
  exit(1)
end

dl_ret = download_xml(kouza)
if dl_ret[:xml].nil? then
  $stderr.puts("番組データ XML ダウンロードエラー")
  $stderr.puts("#{dl_ret[:http_response].code}: #{dl_ret[:http_response].message}")
  $stderr.puts("番組パスの指定が間違っているかもしれません。指定された番組パス: #{kouza}")
  $stderr.puts("正しい番組パスの一覧は、このコマンドを引数なしで実行すると見られます。")
  exit(1)
end

doc = REXML::Document.new(dl_ret[:xml])

musicdata = []

REXML::XPath.match(doc, "/musicdata/music").map do |music|
  musicdata << Music.new(music)
end

ret = 0

musicdata.each do |music|
  puts("Title  : #{music.title}")
  puts("Date   : #{music.hdate}")
  puts("Kouza  : #{music.kouza}")
  puts("Code   : #{music.code}")
  puts("File   : #{music.file}")
  puts("Nendo  : #{music.nendo}")
  puts("PG Code: #{music.pgcode}")
  puts("URL    : #{music.audio_url}")
  dl_ret = download(music, outdir)
  if dl_ret == :dl_success then
    $stderr.puts("ダウンロード成功。")
  elsif dl_ret == :dl_error then
    $stderr.puts("ダウンロードエラー。")
    ret += 1
  elsif dl_ret == :file_exists then
    $stderr.puts("ファイルが存在します。上書きせずにスキップします。")
  end
  puts("---")
end

exit(ret)
