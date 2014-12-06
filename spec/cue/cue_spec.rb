require 'spec_helper.rb'

include CueSplitter

describe CueInfo do
  before { @cl = CueInfo }
  subject { @cl }

  it { should respond_to(:parse).with(1).argument }
  describe '#parse' do
    let(:cue) {  "#{MEDIA}/cuesheet.cue" }
    it 'returns CueInfo' do
      expect(CueInfo.parse cue).to be_a CueInfo
    end
    describe 'returned Info' do
      subject { CueInfo.parse cue }

      it { should respond_to :performer }
      it { should respond_to :genre }
      it { should respond_to :date }
      it { should respond_to :title }
      it { should respond_to :tracks }

      describe 'has tracks' do
        subject { CueInfo.parse(cue).tracks }
        it { is_expected.to be_an Array }

        describe ', each has' do
          subject { CueInfo.parse(cue).tracks.first }
          
          it { is_expected.to be_a Track }

          it { should respond_to :title }
          its(:title) { is_expected.to be_a String }

          it { should respond_to :performer }
          its(:performer) { is_expected.to be_a String }

          it { should respond_to :index }
          its(:index) { is_expected.to match(/\d\d\s+(\d+:\s+){2}\d+/) }

          it { should respond_to :pregap }
          its(:pregap) { is_expected.to match(/\d\d\s+(\d+:\s+){2}\d+/) }

          it { should respond_to :postgap }
          its(:postgap) { is_expected.to match(/\d\d\s+(\d+:\s+){2}\d+/) }
        end
      end
    end
  end
end
