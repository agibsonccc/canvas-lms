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

require 'ostruct'
class OpenObject < OpenStruct
  attr_accessor :object_type
  def self.build(type, data={})
    data ||= {}
    res = OpenObject.new(data.dup)
    res.object_type = type
    res
  end
  
  def assert_hash_data
    @table ||= {}
  end
  
  def id
    assert_hash_data
    @table && @table[:id]
  end
  
  def type
    assert_hash_data
    @table && @table[:type]
  end
  
  def asset_string
    assert_hash_data
    return @table[:asset_string] if @table[:asset_string]
    return nil unless @table && @table[:type] && @table[:id]
    "#{@table[:type].underscore}_#{@table[:id]}"
  end
  
  def hash_data
    res = {}
    assert_hash_data
    @table.each do |key, value|
      res[key] = value
      if value.is_a? Array
        new_list = []
        res[key].each do |obj|
          if obj.is_a? OpenObject
            new_list << obj.hash_data
          elsif obj.is_a? OpenStruct
            new_list << obj.table
          else
            new_list << obj
          end
        end
        res[key] = new_list
      elsif value.is_a? Time
        res[key] = value.utc.iso8601.to_s
      elsif value.is_a? OpenObject
        res[key] = value.hash_data
      elsif value.is_a? OpenStruct
        res[key] = value.table
      end
    end
    res
  end
  def to_json(context=nil)
    if @object_type
      res = {}
      res[@object_type.to_sym] = self.hash_data
      res.to_json
    else
      self.hash_data.to_json
    end
  end
  def self.process(pre={})
    pre = JSON.parse(pre) if pre.is_a? String
    pre = pre.dup
    if pre.is_a? Array
      new_list = []
      pre.each do |obj|
        new_list << OpenObject.process(obj)
      end
      new_list
    elsif pre
      pre.each do |name, value|
        if value.is_a? Array
          new_list = []
          value.each do |obj|
            if obj.is_a? Hash
              new_list << OpenObject.process(obj)
            else
              new_list << obj
            end
          end
          pre[name] = new_list
        elsif value.is_a? Hash
          pre[name] = OpenObject.process(value)
        end
      end
      OpenObject.new(pre)
    end
  end
end
