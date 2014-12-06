require 'ostruct'
require 'parslet'

module CueSplitter
  class CueInfo
    attr_accessor :performer, :genre,
      :date, :title, :tracks

    def initialize
      @performer = 'Unknown'
      @genre = 'Unknown'
      @date = nil
      @title = 'Unknown'
      @tracks = []
    end

    private

    def add_track(opts = {})
      @tracks << Track.new(
        opts[:title] || 'Unknown',
        opts[:performer] || 'Unknown',
        opts[:index],
        opts[:pregap],
        opts[:postgap]
      )
    end

    class << self
      def parse(filename)
        lines = File.read(filename).lines
        info = CueInfo.new
      end
    end
  end

  class Track < OpenStruct
  end

  class CueParser < Parslet::Parser
    P = Parslet
    rule(:cue) { (rem | performer >> eol | title >> eol | file).repeat(0) }
    rule(:rem) { space? >> P.str('REM') >> rem_internal >> eol }
    rule(:rem_internal) { space? >> (genre | date) }
    rule(:genre) { P.str('GENRE') >> string }
    rule(:date) { P.str('DATE') >> string }
    rule(:performer) { P.str('PERFORMER') >> string }
    rule(:title) { P.str('TITLE') >> string }
    rule(:file) { P.str('FILE') >> string >> eol >> file_internal.repeat(0) }
    rule(:file_internal) { space >> track }
    rule(:track) { P.str('TRACK') >> string >> eol >> (track_internal >> eol).repeat(1) }
    rule(:track_internal) { space >> (index | title | pregap | postgap) }
    rule(:index) { P.str('INDEX') >> string }
    rule(:pregap) { P.str('PREGAP') >> string }
    rule(:postgap) { P.str('POSTGAP') >> string }
    rule(:eol) { match('[\r\n]').repeat(1) }
    rule(:string) { match('[^\r\n]').repeat(1) }
    rule(:space) { match('[\s\t]').repeat(1) }
    rule(:space?) { space.maybe }
    root :cue
  end
end
