require 'rails_helper'
require_relative '../support/image_content_helper'

RSpec.describe 'ImageContent', type: :model do
  include_context 'db_cleanup'
  include ImageContentHelper
  let(:fin) { image_file }

  context 'BSON::Binary' do
    it 'demonstrates BSON::Binary' do
      binary = BSON::Binary.new(fin.read)
      expect(binary.data.size).to eq(fin.size)

      fout = File.open('tmp/out.jpg', 'wb')
      fout.write(binary.data)
      expect(fout.size).to eq(fin.size)
    end

    context 'using helper' do
      it 'derives BSON::Binary from file' do
        binary = ImageContent.to_binary fin
        expect(binary.class).to be(BSON::Binary)
        expect(binary.data.size).to eq(fin.size)
      end
      it 'derives BSON::Binary from StringIO' do
        strio = StringIO.new(fin.read)
        binary = ImageContent.to_binary(strio)
        expect(binary.class).to be(BSON::Binary)
        expect(binary.data.size).to eq(fin.size)
      end
      it 'derives BSON::Binary from BSON::Binary' do
        binary = BSON::Binary.new(fin.read)
        binary = ImageContent.to_binary(binary)
        expect(binary.class).to be(BSON::Binary)
        expect(binary.data.size).to eq(fin.size)
      end
      it 'derives BSON::Binary from base64 encoded String' do
        content = BSON::Binary.new(fin.read)
        b64 = Base64.encode64(content.data)
        binary = ImageContent.to_binary(b64)
        expect(binary.class).to be(BSON::Binary)
        expect(binary.data.size).to eq(fin.size)
      end
    end
  end

  context 'assign content' do
    it 'sets content' do
      strio = StringIO.new(fin.read)
      ic = ImageContent.new
      ic.content = strio
      expect(ic.content.class).to be(BSON::Binary)
      expect(ic.content.data.size).to eq(fin.size)
    end

    it 'mass-assigns content' do
      strio = StringIO.new(fin.read)
      ic = ImageContent.new(content: strio)
      expect(ic.content.class).to be(BSON::Binary)
      expect(ic.content.data.size).to eq(fin.size)
    end
  end

  context 'valid image content' do
    it 'requires image'
    it 'requires content_type'
    it 'requires content'
    it 'requires width'
    it 'requires height'
    it 'requires supported content_type'
    it 'checks content size maximum'
  end

  context 'Image scaling' do
    it 'creates for Image with ImageContent'
    it 'creates for Image and ImageContent'
  end

  context 'content for image' do
    it 'find for image'
    it 'find by size'
    it 'find largest'
    it 'delete for image'
  end
end
