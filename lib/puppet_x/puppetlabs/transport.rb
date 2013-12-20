module PuppetX
  module Puppetlabs
    module Transport
      @@instances = []
      # Accepts a puppet resource reference, resource catalog, and loads connetivity info.
      def self.retrieve(options={})
        unless res_hash = options[:resource_hash]
          catalog = options[:catalog]
          res_ref = options[:resource_ref].to_s
          name = Puppet::Resource.new(nil, res_ref).title
          res_hash = catalog.resource(res_ref).to_hash
        end

        provider = options[:provider]

        #unless transport = find(name, provider)
        transport = PuppetX::Puppetlabs::Transport::const_get(provider.to_s.capitalize).new(res_hash)
        transport.connect
        @@instances << transport
        #end

        transport
      end

      def self.cleanup
        @@instances.each do |index|
          index.close if index.respond_to? :close
        end
      
      end

      private

      def self.find(name, provider)
        Puppet.debug "------ in find-------" + provider.to_s.capitalize
        @@instances.find{ |counter| counter.is_a? PuppetX::Puppetlabs::Transport::const_get(provider.to_s.capitalize) and counter.name == name }
        Puppet.debug "------ in find-------" + @@instances
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      def transport
        self.class.transport(resource)
      end

      module ClassMethods
        def transport(resource)
          @transport ||= PuppetX::Puppetlabs::Transport.retrieve(
          :resource_ref => resource[:transport],
          :catalog => resource.catalog,
          :provider => resource.provider.class.name
          )
        end
      end
    end
  end
end
