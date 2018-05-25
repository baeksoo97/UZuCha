// routes/index.js

module.exports = function(app, Parking, db)
{
    app.get('/', function (req, res) {
        res.send('<html><body><h1>Server is On!</h1></body></html>');

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
                
                building_name: "김원준의 해피하우스",
                //building_image_dir: [ {img_dir: String} ], 
                building_address: "서울시 성동구 사근동 61길, 광덕 빌딩",
                
                // park_owner
                owner_name: "김원준",
                owner_mail_address: "abc123@naver.com",
                owner_phone_number: "010-2915-1816",
                
                price: "1000원 / 시간",
                availabe_time: "하루 종일",
                //is_favorite: { type: Boolean, default: false },

                owner_comment: "흥정 없습니다.. 쿨거래 원합니다 ^^",
    
                //created_at: { type: Date, default: Date.now }
    
            }).save();

            new Parking({
                google_mark: {
                    longitude: 37.560975,
                    latitude: 127.045738
                },
                
                building_name: "샘플빌딩",
                //building_image_dir: [ {img_dir: String} ], 
                building_address: "서울시 성동구 사근동 58길, 샘플빌딩",
                
                // park_owner
                owner_name: "김부자",
                owner_mail_address: "abc123@gmail.com",
                owner_phone_number: "010-1313-2424",
                
                price: "한달 정기권 5만원",
                availabe_time: "저녁에만 가능",
                //is_favorite: { type: Boolean, default: false },

                owner_comment: "안녕 얘들아 많이 이용해줘",
    
                //created_at: { type: Date, default: Date.now }
    
            }).save();
        });
    });

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

    

    // GET PARKINGS SEARCHED BY BY BUILDING NAME
    app.get('/api/parkings/author/:author', function(req, res){
        // 2nd parameter : projection (1: show)
        Parking.find({building_name: req.params.building_name}, {_id: 0, owner_name: 1, created_at: 1},  function(err, parkings){
            if(err) return res.status(500).json({error: err});
            if(parkings.length === 0) return res.status(404).json({error: 'parking not found'});
            res.json(parkings);
        })
    });


    // ------------------------------------------------------

    // CREATE PARKING
    // USING POST METHOD. UPLOAD WITH JSON

    app.post('/api/parkings', function(req, res){
        
        var reqBody = req.body;

        var parking = new Parking({
            google_mark: {
                longitude: reqBody.longitude,
                latitude: reqBody.latitude
            },
            
            building_name: reqBody.building_name,
            //building_image_dir: [ {img_dir: String} ], 
            building_address: reqBody.building_address,
            
            // park_owner
            owner_name: reqBody.owner_name,
            owner_mail_address: reqBody.owner_mail_address,
            owner_phone_number: reqBody.owner_phone_number,
            
            price: "1000원 / 시간",
            availabe_time: "하루 종일",
            //is_favorite: { type: Boolean, default: false },

            owner_comment: "흥정 없습니다.. 쿨거래 원합니다 ^^",

            //created_at: { type: Date, default: Date.now }

        });

        /*
        parking.building_name = req.body.building_name;
        parking.building_image_dir = req.body.building_image_dir;
        parking.building_address = req.body.building_address;

        parking.park_owner.owner_name = req.body.owner_name;

        book.save(function(err) {
            if (err) {
                console.error(err);
                res.json({result : 0});
                return;
            }

            res.json({result : 1});
            

        });
        */
       Parking.create(req.body, function(err, post) {
           if (err) {
               console.error(err);
               res.json({result : 0});
               return;
           }

           res.json({result : 1});

       });
    });

    // UPDATE THE BOOK
    // USING PUT METHOD
    app.put('/api/parkings/:parking_id', function(req, res){
        Book.findById(req.params.book_id, function(err, book){
            if(err) return res.status(500).json({ error: 'database failure' });
            if(!book) return res.status(404).json({ error: 'book not found' });
    
            if(req.body.title) book.title = req.body.title;
            if(req.body.author) book.author = req.body.author;
            if(req.body.published_date) book.published_date = req.body.published_date;
    
            book.save(function(err){
                if(err) res.status(500).json({error: 'failed to update'});
                res.json({message: 'book updated'});
            });
    
        });
    });

    // DELETE BOOK
    app.delete('/api/parkings/:book_id', function(req, res){
        Book.remove({ _id: req.params.book_id }, function(err, output){
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