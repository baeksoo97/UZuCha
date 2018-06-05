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
        available_time: String,
    },

    price: { type: String, required: true},
    is_favorite: { type: Boolean, default: false},
    owner_comment: String,

    created_at: { type: Date, default: Date.now }
});

// virtual getter for getting date in format
ParkingSchema.virtual('getDate').get(function(){
    var date = new Date(this.created_at);
    return {
        year : date.getFullYear(),
        month : date.getMonth()+1,
        day : date.getDate(),
        hours : date.getHours(),
        minutes : date.getMinutes(),
        seconds : date.getSeconds()
    };
});


module.exports = mongoose.model('parking', ParkingSchema);