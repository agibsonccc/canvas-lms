#
# Copyright (C) 2011 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe MediaObject do
  context "loading with legacy support" do
    it "should load by either media_id or old_media_id" do
      course
      mo = factory_with_protected_attributes(MediaObject, :media_id => '0_abcdefgh', :old_media_id => '1_01234567', :context => @course)
      
      MediaObject.by_media_id('0_abcdefgh').first.should == mo
      MediaObject.by_media_id('1_01234567').first.should == mo
    end
    
    it "should raise an error if someone tries to use find_by_media_id" do
      lambda { MediaObject.find_by_media_id('fjdksl') }.should raise_error
    end
  end
end
