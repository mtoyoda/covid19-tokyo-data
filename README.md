東京都の新型コロナウイルス陽性者の区市町村別統計データ
======================================================

# 概要

[東京都 新型コロナウイルス感染症対策サイト](https://stopcovid19.metro.tokyo.lg.jp/)で公開されている区市町村別の陽性者データの履歴をgithubのコミットログから抽出し日毎のCSVファイルに変換するスクリプトと変換済みのデータを公開しています。

上記サイトにある元データにはいくつかの日付のつけ間違いが存在しており、可能な限り人手で修正をしていますが、完全ではない可能性がありますのでご注意ください。

# データ

データのみ必要な人は、 district-wise-patients ディレクトリにある以下のファイルをお使いください。
- date_district_num.csv (区市町村ごとの累積陽性者数)
- date_district_diff.csv (区市町村ごとの1日の新規陽性者数)

# スクリプトによるデータの生成と更新

このリポジトリを clone して、generate.sh を実行することでデータの生成と更新を手元で行うことができます。

実行するには、JSON::XS モジュールをインストールした perl 5 が必要です。


