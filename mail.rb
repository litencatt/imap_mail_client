require 'net/imap'
require 'bundler/setup'
Bundler.require
Dotenv.load

# IMAP接続設定
imap_host   = ENV['IMAP_HOST']
imap_port   = ENV['IMAP_PORT']
imap_usessl = true
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
mail = Mail.new(data[0].attr["RFC822"])
puts mail.text_part.decoded

imap.close

# 日本語での#search
# imap.search(['SUBJECT', '日本語'.force_encoding('ASCII-8BIT')], 'utf-8')
