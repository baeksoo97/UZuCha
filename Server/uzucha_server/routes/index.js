// routes/index.js

module.exports = function(app, Parking, db, serializer, upload)
{


    // Upload Page
    app.get('/upload',function(req,res){
        res.render('upload.html');
    });

    // home page
    app.get('/', function(req,res) {
        res.render('home.ejs');
    });

    // parkings list pages
    app.get('/admin/parkings', function(req,res) {
        Parking.find(function(err, parkings){
            res.render('admin/parkings',
                { parkings : parkings }
            );
        });
    });

    // single parking list
    app.get('/admin/parkings/detail/:id' , function(req, res){
        //url 에서 변수 값을 받아올떈 req.params.id 로 받아온다
        Parking.findOne( { '_id' :  req.params.id } , function(err ,parking){
            res.render('admin/parkingsDetail', { parking: parking });  
        });
    });

    // parking write pages
    app.get('/admin/parkings/write', function(req,res){
        res.render( 'admin/form');
    });

    // write 글쓰기로 등록
    // USE POST METHOD
    app.post('/admin/parkings/write', function(req, res) {
        var reqBody = req.body;

        // get json data from request
        var parking = new Parking({
            google_mark: {
                longitude: reqBody.longitude,
                latitude: reqBody.latitude
            },

            building: {
                building_name: reqBody.building_name,
                building_image_dir: reqBody.building_image_dir, 
                building_address: reqBody.building_address
            },

            owner : {
                owner_name: reqBody.owner_name,
                owner_mail_address: reqBody.owner_mail_address,
                owner_phone_number: reqBody.owner_phone_number
            },

            detail : {
                capacity: reqBody.capacity,
                floor: reqBody.floor,
                available_time: reqBody.available_time
            },

            price: reqBody.price,
            owner_comment: reqBody.owner_comment,
        });

        // save data in DB
        parking.save(function(err, parking) {
            if(err) {
                console.error(err);
                res.json({result : 0});
                return;
            }
            // return to original page
            res.redirect('/admin/parkings')
        });
        
    
    });

    // upload request 
    app.post('/upload', upload.single('userPic'), function(req, res){
        res.render('upload.html');
        console.log(req.file);
        /*
        var reqBody = req.body;

        // get json data from request
        var parking = new Parking({
            google_mark: {
                longitude: reqBody.google_mark.longitude,
                latitude: reqBody.google_mark.latitude
            },

            building: {
                building_name: reqBody.building.building_name,
                building_image_dir: reqBody.building.building_image_dir, 
                building_address: reqBody.building.building_address
            },

            owner : {
                owner_name: reqBody.owner.owner_name,
                owner_mail_address: reqBody.owner.owner_mail_address,
                owner_phone_number: reqBody.owner.owner_phone_number
            },

            detail : {
                capacity: reqBody.detail.capacity,
                floor: reqBody.detail.floor,
                available_time: reqBody.detail.available_time
            },

            is_favorite: reqBody.is_favorite,
            price: reqBody.price,
            owner_comment: reqBody.owner_comment,
        });

        // save data in DB
        parking.save(function(err, parking) {
            if(err) {
                console.error(err);
                res.json({result : 0});
                return;
            }
            // return ID of element in response
            res.json({result : 1, id : parking._id});
            res.status(200).end();
        });
        */
      });

      

      // 기본 data inputSet 입력
    app.get('/basic', function (req, res) {
        res.send('<html><body><h1>basic Data initialize</h1></body></html>');

        // DB initialization
        Parking.find(function(err, parkings) {
            if (parkings.length != 0) {
                // ignore if already initialized
                return;
            }

            new Parking({
                google_mark: {
                    longitude: 37.561059,
                    latitude: 127.047754
                },

                building: {
                    building_name: "김원준의 해피하우스",
                    building_image_dir: ["images/1_1.jpg", "images/1_2.jpg", "images/1_3.jpg"], 
                    building_address: "서울시 성동구 사근동 61길, 광덕 빌딩"
                },

                owner : {
                    owner_name: "김원준",
                    owner_mail_address: "abc123@naver.com",
                    owner_phone_number: "010-2915-1816",
                },

                detail : {
                    capacity: 10,
                    floor: 3,
                    available_time: "하루 종일",
                },
                price: "1000원 / 시간",
                owner_comment: "흥정 없습니다.. 쿨거래 원합니다 ^^",
    
            }).save();

            new Parking({
                google_mark: {
                    longitude: 37.560975,
                    latitude: 127.045738
                },

                building: {
                    building_name: "샘플빌딩",
                    building_image_dir: ["images/2_1.jpg", "images/2_2.jpg", "images/2_3.jpg"],
                    building_address: "서울시 성동구 사근동 58길, 샘플빌딩"
                },

                owner : {
                    owner_name: "김부자",
                    owner_mail_address: "abc123@gmail.com",
                    owner_phone_number: "010-1313-2424"
                },

                detail : {
                    capacity: 2,
                    floor: 2,
                    available_time: "평일 오후 5시~ 10시 사이에만 가능",
                },

                price: "한달 정기권 5만원",
                owner_comment: "안녕 얘들아 많이 이용해줘",
    
            }).save();
        });
    });


    //-------------------------------------------------------
    // -------------------REST API REQUESTS------------------
    //-------------------------------------------------------
    // GET ALL PARKINGS
    app.get('/api/parkings', function(req,res){
        Parking.find(function(err, parkings){
            if(err) return res.status(500).send({error: 'database failure'});
            
            res.json(parkings);
        })
    });

    // GET SINGLE PARKING
    // GET by ID
    app.get('/api/parkings/:parking_id', function(req, res){

        Parking.findOne({_id: req.params.parking_id}, function(err, parking){
            if(err) return res.status(500).json({error: err});
            if(!parking) return res.status(404).json({error: 'parking not found'});
            res.json(parking);
        })


    });

    

    // GET PARKING IMAGE DIRECTORIES IN ONE PARKING
    // GET by ID
    app.get('/api/parkings/images/:parking_id', function(req, res){
        // 2nd parameter : projection (1: show)
        Parking.findOne({_id: req.params.parking_id}, {building_image_dir: 1},  function(err, parking){
            if(err) return res.status(500).json({error: err});
            if(!parking) return res.status(404).json({error: 'parking not found'});
            res.json(parking);
        })
    });


    // GET json lists with matching price
    // which contains parking_price string
    // GET by price
    app.get('/api/parkings/price/:parking_price', function(req, res){

        Parking.find({price: {$regex : req.params.parking_price}}, function(err, parking){
            if(err) return res.status(500).json({error: err});
            if(!parking) return res.status(404).json({error: 'parkings not found'});
            res.json(parking);
        })
    });

    // GET json lists with matching building_name
    // which contains building_name string
    // GET by building name
    app.get('/api/parkings/buildin_name/:building_name', function(req, res){

        Parking.find({'building.building_name': {$regex : req.params.building_name}}, function(err, parking){
            if(err) return res.status(500).json({error: err});
            if(!parking) return res.status(404).json({error: 'parkings not found'});
            res.json(parking);
        })
    });

    // GET json lists with matching building_address
    // which contains building_address string
    // GET by building address
    app.get('/api/parkings/building_address/:building_address', function(req, res){

        Parking.find({'building.building_address': {$regex : req.params.building_address}}, function(err, parking){
            if(err) return res.status(500).json({error: err});
            if(!parking) return res.status(404).json({error: 'parkings not found'});
            res.json(parking);
        })
    });




    // CREATE PARKING
    // USING POST METHOD. UPLOAD WITH JSON
    app.post('/api/parkings', function(req, res){
        
        var reqBody = req.body;

        // get json data from request
        var parking = new Parking({
            google_mark: {
                longitude: reqBody.google_mark.longitude,
                latitude: reqBody.google_mark.latitude
            },

            building: {
                building_name: reqBody.building.building_name,
                building_image_dir: reqBody.building.building_image_dir, 
                building_address: reqBody.building.building_address
            },

            owner : {
                owner_name: reqBody.owner.owner_name,
                owner_mail_address: reqBody.owner.owner_mail_address,
                owner_phone_number: reqBody.owner.owner_phone_number
            },

            detail : {
                capacity: reqBody.detail.capacity,
                floor: reqBody.detail.floor,
                available_time: reqBody.detail.available_time
            },

            is_favorite: reqBody.is_favorite,
            price: reqBody.price,
            owner_comment: reqBody.owner_comment,
        });

        // save data in DB
        parking.save(function(err, parking) {
            if(err) {
                console.error(err);
                res.json({result : 0});
                return;
            }
            // return ID of element in response
            res.json({result : 1, id : parking._id});
            res.status(200).end();
        });
    });

    
    // UPDATE THE PARKING FAVORITE
    // USING PUT METHOD
    app.put('/api/parkings/toggleFavorite/:parking_id', function(req, res){

        Parking.findById(req.params.parking_id, function(err, parking){
            if(err) return res.status(500).json({ error: 'database failure' });
            if(!parking) return res.status(404).json({ error: 'parking not found' });

            if (parking.is_favorite == true) {
                parking.is_favorite = false;
            } else {
                parking.is_favorite = true;
            }

            parking.save(function(err){
                if(err) res.status(500).json({error: 'failed to update'});
                res.json({message: 'parking favorite changed'});
            });
    
        });
    });
    

    // ------------------------------------------------------

    // DELETE PARKING
    app.delete('/api/parkings/:parking_id', function(req, res){
        Parking.remove({ _id: req.params.parking_id}, function(err, output){
            if(err) return res.status(500).json({ error: "database failure" });
    
            /* ( SINCE DELETE OPERATION IS IDEMPOTENT, NO NEED TO SPECIFY )
            if(!output.result.n) return res.status(404).json({ error: "book not found" });
            res.json({ message: "book deleted" });
            */
            res.status(204).end();
        })
    });

    // Use Express midleware to handle 404 and 500 error states.
    app.use(function(request, response){
        // Set status 404 if none of above routes processed incoming request. 
        response.status(404); 
        // Generate the output.
        response.send('404 - not found');
    });

    // 500 error handling. This will be handled in case of any internal issue on the host side.
    app.use(function(err, request, response){
        // Set response type to application/json.
        response.type('application/json');
        // Set response status to 500 (error code for internal server error).
        response.status(500);
        // Generate the output - an Internal server error message. 
        response.send('500 - internal server error');
    });


}