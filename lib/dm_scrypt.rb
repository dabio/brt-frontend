# encoding: utf-8

module DataMapper
  class Property

    class SCryptHash < String

      length  100
      lazy    true

      def primitive?(value)
        value.kind_of?(SCrypt::Password)
      end

      def load(value)
        unless value.nil?
          begin
            primitive?(value) ? value : SCrypt::Password.new(value)
          rescue SCrypt::Errors::InvalidHash
            SCrypt::Password.create(value)
          end
        end
      end

      def dump(value)
        load(value)
      end

      def typecast_to_primitive(value)
        load(value)
      end
    end

  end
end
