TableGeoset = []

TableGeoset.push
    name     : 'ID'
    source   : 'id'
    visible  : true
    editable : false
    type     : 'int'
    required : true
    width    : 40

TableGeoset.push
    name     : 'Modified'
    source   : 'lastModified'
    visible  : true
    editable : false
    type     : 'timeago'
    width    : 120

TableGeoset.push
    name    : "Title"
    source  : "title"
    type    : "text"
    editable: true
    visible : true

TableGeoset.push
    name     : "Dataset Type"
    source   : "dataset_type"
    type     : "enum"
    width    : 100
    editable : true
    options  : [ "Parcel", "Flood Plane", "Rail", "Utilitiy", "Other" ]
    visible  : true

TableGeoset.push
    name     : "Description"
    source   : "description"
    type     : "text"
    editable : true
    visible  : false

TableGeoset.push
    name   : "Metro Area"
    source : "metro_area"
    type   : "text"
    width  : 100
    visible  : true

TableGeoset.push
    name     : "Source"
    visible  : false
    source   : "source_url"
    type     : "text"
    width    : 100
    visible  : true
    editable : true

TableGeoset.push
    name     : 'Points'
    source   : 'total_points'
    visible  : true
    editable : false
    type     : 'int'
    required : true
    width    : 70
    visible  : true

TableGeoset.push
    name     : 'BBox'
    source   : 'bbox'
    visible  : true
    editable : false
    type     : 'text'
    required : true
    width    : 150
    visible  : true
    render   : (val, obj) =>
        if !val? or val == null or !val[0]? or !val[2]
            return "<i>Not defined</i>"

        return "[#{val[0]}, #{val[1]}]-[#{val[2]},#{val[3]}]"


$ ->

    ##|
    ##| Configure the global map
    DataMap.setDataTypes "geoset", TableGeoset
