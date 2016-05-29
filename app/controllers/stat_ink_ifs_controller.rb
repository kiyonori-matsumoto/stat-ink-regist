require 'json'
require 'open-uri'

class StatInkIfsController < ApplicationController
  GAMEMODES = { ranked: "ガチマッチ", regular: "ナワバリバトル",
                festival: "フェスマッチ" }.freeze

  GM = [:ranked, :regular, :festival].freeze
  RK = { "ガチエリア" => :area, "ガチヤグラ" => :yagura, "ガチホコ" => :hoko }.freeze
  WEAPONS_URI = 'https://stat.ink/api/v1/weapon'.freeze
  MAP_URI = 'https://stat.ink/api/v1/map'.freeze
  # WEAPONS_URI = "#{Rails.root}/lib/assets/weapon.json".freeze
  SCHEDULE_URI = 'http://splatapi.ovh/schedule_jp.json'.freeze

  def new
    @gm = GM.find { |e| params[e] }
    redirect_to action: :index if @gm.nil?
    @gamemode = GAMEMODES[@gm]
    @gamemode_sub = if @gm == :ranked then "(#{ranked_mode})" else '' end
    @weapons = weapons
    @stages  = stages(@gm.to_s)
    @lobby = :standard # TODO:
    @rule  = (@gm == :regular) ? :nawabari : ranked_mode_key # TODO:
    @ranks = ['C-', 'C', 'C+', 'B-', 'B', 'B+', 'A-', 'A', 'A+', 'S', 'S+'].map { |e| [e, e.downcase] }
  end

  def create
  end

  def index
  end

  private

  def weapons
    buki = JSON.load(open(WEAPONS_URI))
    r = {}
    buki.each do |b|
      r[b['type']['name']['ja_JP']] ||= []
      r[b['type']['name']['ja_JP']] << [b['name']['ja_JP'], b['key']]
    end
    r
  end

  def ranked_mode_key
    RK[ranked_mode]
  end

  def ranked_mode
    r = schedule['schedule'][0]['ranked_mode']
  end

  def schedule
    @schedule ||= JSON.load(open(SCHEDULE_URI))
  end

  def stages(t)
    m = JSON.load(open(MAP_URI))
    map_kv = Hash[m.map { |e| [e['name']['en_US'], e['key']] }]
    schedule['schedule'][0]['stages'][t].map { |e| [e['name'], map_kv[e['nameEN']]] }
  end
end
