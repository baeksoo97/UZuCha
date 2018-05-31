// models/parking.js

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var ParkingSchema = new Schema({
    // Google Map
    google_mark: {
        longitude: { type: Number, required: true},
        latitude: { type: Number, required: true},
        markerName: String
    },

    building: {
        building_name: { type: String, required: true},
        building_image_dir: [ {type: String} ], 
        building_address: { type: String, required: true}
    },
    
    // park_owner
    owner : {
        owner_name: { type: String, required: true},
        owner_mail_address: String,
        owner_phone_number: String
    },

    detail : {
        capacity: Number,
        floor: Number,
        availabe_time: String,
    },

    price: { type: String, required: true},
    is_favorite: { type: Boolean, default: false},
    owner_comment: String,

    created_at: { type: Date, default: Date.now }
});

module.exports = mongoose.model('parking', ParkingSchema);