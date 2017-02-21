# encoding: utf-8
require 'spec_helper'

module YardToDocset
  describe Yard do
    context '#generate' do
      it 'raises an exception when directory not exists' do
        expect { described_class.generate 'wrong path params' }
          .to raise_exception described_class::DirectoryNotExists
      end

      it 'raises an exception when both +gem_name+ and +path_to_sources+ not present' do
        expect { described_class.generate __dir__ }
          .to raise_exception described_class::ParamsNotSpecified
      end
    end # context '#generate'


    context '#download_from_rubydoc' do
      it 'raises an exception when private method called' do
        expect { described_class.download_from_rubygems }
          .to raise_exception NoMethodError
      end
    end # context 'download_from_rubydoc'


    context '#parse_sources' do
      it 'raises an exception when private method called' do
        expect { described_class.parse_sources }
          .to raise_exception NoMethodError
      end
    end # context '#parse_sources'
  end # describe Yard
end # module YardToDocset
