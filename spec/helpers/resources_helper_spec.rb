require 'rails_helper'

RSpec.describe ResourcesHelper do
  let!(:enterprise) { create(:enterprise) }
  let!(:image) { File.new('spec/fixtures/files/verizon_logo.png') }
  let!(:resource_with_file) { create(:resource, file: image,  enterprise: enterprise) }
  let!(:resource_with_no_file) { create(:resource, file: nil, enterprise: enterprise) }

  describe '#thumbnail_for_resource' do
    it 'returns default image_url if file is absent for resource' do
      expect(thumbnail_for_resource(resource_with_no_file)).to eq image_url('icons/filetypes/other.png')
    end

    it 'return expiring url if file is an image' do
      expect(thumbnail_for_resource(resource_with_file)).to eq resource_with_file.file.expiring_url(3600)
    end
  end

  describe '#thumbnail_for_resource_extension' do
    it 'returns word.png when file_extension is .doc' do
      doc = File.new('spec/fixtures/files/quarterly_report.doc')
      resource = create(:resource, file: doc)

      expect(thumbnail_for_resource_extension(resource)).to eq 'word.png'
    end

    it 'returns pdf.png when file_extension is .pdf' do
      pdf = File.new('spec/fixtures/files/case_study.pdf')
      resource = create(:resource, file: pdf)

      expect(thumbnail_for_resource_extension(resource)).to eq 'pdf.png'
    end

    it 'returns excel.png when file_extension is .csv' do
      csv = File.new('spec/fixtures/files/diverst_csv_import.csv')
      resource = create(:resource, file: csv)

      expect(thumbnail_for_resource_extension(resource)).to eq 'excel.png'
    end

    it 'returns powerpoint.png when file_extension is ppt' do
      ppt = File.new('spec/fixtures/files/demo_presentation.ppt')
      resource = create(:resource, file: ppt)

      expect(thumbnail_for_resource_extension(resource)).to eq 'powerpoint.png'
    end

    it 'returns archive.png when file_extension is rar' do
      rar = File.new('spec/fixtures/files/archives.rar')
      resource = create(:resource, file: rar)

      expect(thumbnail_for_resource_extension(resource)).to eq 'archive.png'
    end

    it 'returns video.png when file_extension is video' do
      video = File.new('spec/fixtures/video_file/sponsor_video.mp4')
      resource = create(:resource, file: video)

      expect(thumbnail_for_resource_extension(resource)).to eq 'video.png'
    end

    it 'returns other.png when file_extension is not part of whitelisted extensions' do
      svg = File.new('spec/fixtures/files/diverst_logo.svg')
      resource = create(:resource, file: svg)

      expect(thumbnail_for_resource_extension(resource)).to eq 'other.png'
    end
  end

  describe '#thumbnail_for_answer' do
    it 'returns thumbnail for answer when supporting_document is an image' do
      document = File.new('spec/fixtures/files/gold_star.jpg')
      answer = create(:answer, supporting_document: document, author: create(:user))

      expect(thumbnail_for_answer(answer)).to eq answer.supporting_document.url
    end
  end

  describe '#thumbnail_for_answer_extension' do
    it 'returns word.png when file_extension is .doc' do
      doc = File.new('spec/fixtures/files/quarterly_report.doc')
      answer = create(:answer, supporting_document: doc)

      expect(thumbnail_for_answer_extension(answer)).to eq 'word.png'
    end

    it 'returns pdf.png when file_extension is .pdf' do
      pdf = File.new('spec/fixtures/files/case_study.pdf')
      answer = create(:answer, supporting_document: pdf)

      expect(thumbnail_for_answer_extension(answer)).to eq 'pdf.png'
    end

    it 'returns excel.png when file_extension is .csv' do
      csv = File.new('spec/fixtures/files/diverst_csv_import.csv')
      answer = create(:answer, supporting_document: csv)

      expect(thumbnail_for_answer_extension(answer)).to eq 'excel.png'
    end

    it 'returns powerpoint.png when file_extension is ppt' do
      ppt = File.new('spec/fixtures/files/demo_presentation.ppt')
      answer = create(:answer, supporting_document: ppt)

      expect(thumbnail_for_answer_extension(answer)).to eq 'powerpoint.png'
    end

    it 'returns archive.png when file_extension is rar' do
      rar = File.new('spec/fixtures/files/archives.rar')
      answer = create(:answer, supporting_document: rar)

      expect(thumbnail_for_answer_extension(answer)).to eq 'archive.png'
    end

    it 'returns video.png when file_extension is video' do
      video = File.new('spec/fixtures/video_file/sponsor_video.mp4')
      answer = create(:answer, supporting_document: video)

      expect(thumbnail_for_answer_extension(answer)).to eq 'video.png'
    end

    it 'returns other.png when file_extension is not part of whitelisted extensions' do
      svg = File.new('spec/fixtures/files/diverst_logo.svg')
      answer = create(:answer, supporting_document: svg)

      expect(thumbnail_for_answer_extension(answer)).to eq 'other.png'
    end
  end

  describe '#get_folders_url' do
    it 'returns url for enterprise folders when folder.enterprise is true' do
      folder = create(:folder, group: nil, enterprise: enterprise)
      expect(get_folders_url(folder, 10, :json)).to eq enterprise_folders_path(enterprise, limit: 10, format: :json)
    end

    it 'returns url for group folders when folder.group is true' do
      folder = create(:folder, group: create(:group), enterprise: nil)
      expect(get_folders_url(folder, 10, :json)).to eq group_folders_path(folder.group, limit: 10, format: :json)
    end
  end
end
