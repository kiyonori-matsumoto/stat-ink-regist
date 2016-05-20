class StatInkIfsController < ApplicationController
  GAMEMODES = { ranked: "ガチマッチ", regular: "ナワバリバトル",
                festival: "フェスマッチ" }.freeze

  GM = [:ranked, :regular, :festival].freeze
  def new
    @gm = GM.find { |e| params[e] }
    @gamemode = GAMEMODES[@gm]
    @weapons = weapons
    @stages  = stages
  end

  def create
  end

  def index
  end

  private

  def weapons
    { "ホクサイ" => 'hokusai', ".52ガロン" => '52galon' }
  end

  def stages
    [%w(ハコフグ倉庫 hakofugu), %w(ヒラメが丘団地 hirame)]
  end
end
