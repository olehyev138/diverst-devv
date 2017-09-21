class Segmentation < ActiveRecord::Base
    
    # defines the relationship between two segments
    # a segment can be the parent of a segment and also
    # be the child of another segment - this is to allow nesting of segments
    
    belongs_to :parent, :class_name => "Segment"
    belongs_to :child,  :class_name => "Segment"
end
