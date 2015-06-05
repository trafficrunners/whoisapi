# == Schema Information
#
# Table name: broken_domains
#
#  id         :integer          not null, primary key
#  url        :string
#  error      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BrokenDomain < ActiveRecord::Base
end
