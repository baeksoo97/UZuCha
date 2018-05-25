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

    building_name: { type: String, required: true},
    building_image_dir: [ {img_dir: String} ], 
    building_address: { type: String, required: true},
    
    // park_owner
    owner_name: { type: String, required: true},
    owner_mail_address: String,
    owner_phone_number: String,
    
    price: { type: String, required: true},
    availabe_time: String,
    is_favorite: { type: Boolean, default: false },

    owner_comment: String,

    created_at: { type: Date, default: Date.now }
});

module.exports = mongoose.model('parking', ParkingSchema);

/*

건물 사진
건물 이름
건물 주소

건물주
    (이름) (key)
    (메일주소)
    (전화번호)

건물 가격 (string)
가능한 시간대 (string)

관심목록인지 아닌지 (boolean)

상세 설명
담당자 한마디

등록 시간
*/