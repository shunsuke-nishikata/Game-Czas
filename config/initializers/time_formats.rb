# 曜日の日本語指定
DAT_OF_WEEK = ["日", "月", "火", "水", "木", "金", "土"]

# %Y = 西暦、 %m = 月(2桁)、 %d = 日(2桁)
# 変数展開のためダブルクォーテーション
Time::DATE_FORMATS[:date_jp] = "%m月%d日(#{DAT_OF_WEEK[Date.today.wday]})"

# %H = 時間(2桁)、 %M = 分(2桁)
Time::DATE_FORMATS[:time] = '%H:%M'

# %m = 月(2桁)、 %d = 日(2桁)
Time::DATE_FORMATS[:date] = '%m/%d'