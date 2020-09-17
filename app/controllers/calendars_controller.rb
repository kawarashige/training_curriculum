class CalendarsController < ApplicationController

  require 'date'

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []
    #配列の宣言

    plans = Plan.where(date: @todays_date..@todays_date + 6)
    #whereメソッド、("条件")モデルのテーブル内から条件の合う、レコードを配列の形で取得

    7.times do |x|#xは処理が一回行われる毎に +1 されます
      today_plans = []
      plan = plans.map do |plan|#配列.map {|変数|}で表され、変数に配列の要素が要素の数だけ代入されます。
        today_plans.push(plan.plan) if plan.date == @todays_date + x #もし、＠todays_dateとplanの日付が合ったなら。
        #pushメソッドは引数に要素を複数持ち、一つずつ、配列の要素として入れていきます。
        #カレンダーのplanを代入します。
      end

      wday_num = Date.today.wday

      wday_num += x

      if wday_num >= 7
        wday_num = wday_num - 7
      end

      week_day = wdays[wday_num] #week_dayはwdaysからwday_numを添字として活用し、その値を得ます。

      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, wday: wdays[wday_num]}

      @week_days.push(days)
      #pushメソッドは引数に要素を複数持ち、一つずつ、配列の要素として入れていきます。
    end

  end
end
