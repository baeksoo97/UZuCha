// models/parking.js

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var ParkingSchema = new Schema({
    building_name: String,
    author: String,
    assigned_date: { type: Date, default: Date.now  },

    park_owner: [
    ],
    
    image_dir: [
    ]

});

var ParkingOwnerSchema = new Schema({
    name: String,
});

module.exports = mongoose.model('parking', ParkingSchema, ParkingOwnerSchema,
                                );

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

상세 설명
담당자 한마디
*/