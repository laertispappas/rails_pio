# monkey patch mongoid _id to return id: "string id"
module Mongoid
  module Document
    def as_json(*args)
      res = super
      res["id"] = res.delete("_id").to_s
      res
    end
  end
end
module BSON
  class ObjectId   
    def to_json(*)
      to_s.to_json
    end
    def as_json(*)
      to_s.as_json
    end
  end
end
