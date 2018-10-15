require 'bundler/setup'
require 'net/imap'
require 'kconv'
require 'mail'
require 'pry-byebug'
require 'dotenv'
Dotenv.load

# IMAP接続設定
imap_host = 'imap.gmail.com' # imapをgmailのhostに設定する
imap_usessl = true # imapのsslを有効にする
imap_port = 993 # ssl有効なら993、そうでなければ143
imap = Net::IMAP.new(imap_host, imap_port, imap_usessl)

# IMAPへログイン
imap_user   = ENV['IMAP_USER']
imap_passwd = ENV['IMAP_PASS']
imap.login(imap_user, imap_passwd)

# 対象のメールボックスを選択
#imap.select('INBOX')

# 対象のメールボックスを選択(readonly)
imap.examine('INBOX')

ids = imap.search(['ALL']) # 全てのメールを取得

# メールデータをfetchして本文を出力
data = imap.fetch(ids.first, "RFC822")
meil = Mail.new(data[0].attr["RFC822"])
puts meil.text_part.decoded

imap.close

# 日本語での#search
# imap.search(['SUBJECT', '日本語'.force_encoding('ASCII-8BIT')], 'utf-8')
