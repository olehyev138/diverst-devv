require 'rails_helper'

RSpec.describe CustomText, type: :model do
  describe 'when validating' do
    let(:custom_text) { build_stubbed(:custom_text) }

    it { expect(custom_text).to belong_to(:enterprise) }

    it { expect(custom_text).to validate_length_of(:privacy_statement).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:sub_erg).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:parent).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:member_preference).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:dci_abbreviation).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:dci_full_title).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:segment).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:badge).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:outcome).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:structure).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:program).is_at_most(191) }
    it { expect(custom_text).to validate_length_of(:erg).is_at_most(191) }
  end

  describe '#erg_text' do
    context 'when erg is nil' do
      let(:custom_text) { build_stubbed(:custom_text, erg: nil) }

      it 'returns the default text' do
        expect(custom_text.erg_text).to eq 'Group'
      end
    end

    context 'when erg is present' do
      let(:custom_text) { build_stubbed(:custom_text, erg: 'New ERG') }

      it 'returns the erg text' do
        expect(custom_text.erg_text).to eq 'New ERG'
      end
    end
  end

  describe '#program_text' do
    context 'when program is nil' do
      let(:custom_text) { build_stubbed(:custom_text, program: nil) }

      it 'returns the default text' do
        expect(custom_text.program_text).to eq 'Goal'
      end
    end

    context 'when program is present' do
      let(:custom_text) { build_stubbed(:custom_text, program: 'New Program') }

      it 'returns the program text' do
        expect(custom_text.program_text).to eq 'New Program'
      end
    end
  end

  describe '#structure' do
    context 'when structure is nil' do
      let(:custom_text) { build_stubbed(:custom_text, structure: nil) }

      it 'returns the default text' do
        expect(custom_text.structure_text).to eq 'Structure'
      end
    end

    context 'when structure is present' do
      let(:custom_text) { build_stubbed(:custom_text, structure: 'Orgranizational Architecture') }

      it 'returns the structure text' do
        expect(custom_text.structure_text).to eq 'Orgranizational Architecture'
      end
    end
  end

  describe '#outcome' do
    context 'when outcome is nil' do
      let(:custom_text) { build_stubbed(:custom_text, outcome: nil) }

      it 'returns the default text' do
        expect(custom_text.outcome_text).to eq 'Focus Areas'
      end
    end

    context 'when outcome is present' do
      let(:custom_text) { build_stubbed(:custom_text, outcome: 'Results') }

      it 'returns the outcome text' do
        expect(custom_text.outcome_text).to eq 'Results'
      end
    end
  end

  describe '#badge_text' do
    context 'when badge is nil' do
      let(:custom_text) { build_stubbed(:custom_text, badge: nil) }

      it 'returns the default text' do
        expect(custom_text.badge_text).to eq 'Badge'
      end
    end

    context 'when badge is present' do
      let(:custom_text) { build_stubbed(:custom_text, badge: 'New Badge') }

      it 'returns the badge text' do
        expect(custom_text.badge_text).to eq 'New Badge'
      end
    end
  end

  describe '#segment' do
    context 'when segment is nil' do
      let(:custom_text) { build_stubbed(:custom_text, segment: nil) }

      it 'returns the default text' do
        expect(custom_text.segment_text).to eq 'Segment'
      end
    end

    context 'when segment is present' do
      let(:custom_text) { build_stubbed(:custom_text, segment: 'Region') }

      it 'returns the segment text' do
        expect(custom_text.segment).to eq 'Region'
      end
    end
  end

  describe '#dci_full_title' do
    context 'when dci_full_title is nil' do
      let(:custom_text) { build_stubbed(:custom_text, dci_full_title: nil) }

      it 'returns default text' do
        expect(custom_text.dci_full_title_text).to eq 'Engagement'
      end
    end

    context 'when dci_full_title is present' do
      let(:custom_text) { build_stubbed(:custom_text, dci_full_title: 'Interactions') }

      it 'returns dci_full_title text' do
        expect(custom_text.dci_full_title_text).to eq 'Interactions'
      end
    end
  end

  describe '#dci_abbreviation' do
    context 'when dci_abbreviation is nil' do
      let(:custom_text) { build_stubbed(:custom_text, dci_abbreviation: nil) }

      it 'returns default text' do
        expect(custom_text.dci_abbreviation_text).to eq 'Engagement'
      end
    end

    context 'when dci_abbreviation is present' do
      let(:custom_text) { build_stubbed(:custom_text, dci_abbreviation: 'Interactions') }

      it 'returns dci_abbreviation text' do
        expect(custom_text.dci_abbreviation_text).to eq 'Interactions'
      end
    end
  end

  describe '#member_preference' do
    context 'when member_preference is nil' do
      let(:custom_text) { build_stubbed(:custom_text, member_preference: nil) }

      it 'returns default text' do
        expect(custom_text.member_preference_text).to eq 'Member Survey'
      end
    end

    context 'when member_preference is present' do
      let(:custom_text) { build_stubbed(:custom_text, member_preference: 'Membership Survey') }

      it 'returns member_preference text' do
        expect(custom_text.member_preference_text).to eq 'Membership Survey'
      end
    end
  end

  describe '#parent' do
    context 'when parent is nil' do
      let(:custom_text) { build_stubbed(:custom_text, parent: nil) }

      it 'returns default text' do
        expect(custom_text.parent_text).to eq 'Parent'
      end
    end

    context 'when parent is present' do
      let(:custom_text) { build_stubbed(:custom_text, parent: 'Parent Group') }

      it 'returns dci_abbreviation text' do
        expect(custom_text.parent_text).to eq 'Parent Group'
      end
    end
  end

  describe '#sub_erg' do
    context 'when sub_erg is nil' do
      let(:custom_text) { build_stubbed(:custom_text, sub_erg: nil) }

      it 'returns default text' do
        expect(custom_text.sub_erg_text).to eq 'Sub-Group'
      end
    end

    context 'when sub_erg is present' do
      let(:custom_text) { build_stubbed(:custom_text, sub_erg: 'Sub-Erg') }

      it 'returns sub_erg text' do
        expect(custom_text.sub_erg_text).to eq 'Sub-Erg'
      end
    end
  end

  describe '#privacy_statement' do
    context 'when privacy_statement is nil' do
      let(:custom_text) { build_stubbed(:custom_text, privacy_statement: nil) }

      it 'returns default text' do
        expect(custom_text.privacy_statement_text).to eq 'Privacy Statement'
      end
    end

    context 'when privacy_statement is present' do
      let(:custom_text) { build_stubbed(:custom_text, privacy_statement: 'Privacy Terms') }

      it 'returns privacy_statement text' do
        expect(custom_text.privacy_statement_text).to eq 'Privacy Terms'
      end
    end
  end
end
