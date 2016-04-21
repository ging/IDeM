module Recommendable
	extend ActiveSupport::Concern

	module ClassMethods
		def public
			if self.column_names.include?("draft")
				self.where(:draft => false)
			else
				self
			end
		end
	end

	def profile
		profile = {}
		profile[:title] = self.title if self.respond_to?("title")
		profile[:description] = self.description if self.respond_to?("description")
		profile = profile.recursive_merge(self.extend_profile) if self.respond_to?("extend_profile")
		profile[:id_repository] = self.id
		profile[:repository] = "IDeM"
		profile[:object] = self
		profile
	end
end