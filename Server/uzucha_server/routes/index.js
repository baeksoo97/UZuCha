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
    
                detailed_info: "매우 쾌적한 넓은 공간 보유중 ^^ 항시 대기중.. 연락주세요 ^^",
                owner_comment: "흥정 없습니다.. 쿨거래 원합니다 ^^",
    
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

    // ------------------------------------------------------

    // GET PARKING BY LOCATION
    app.get('/api/parkings/author/:author', function(req, res){
        // 2nd parameter : projection (1: show)
        Book.find({author: req.params.author}, {_id: 0, title: 1, published_date: 1},  function(err, books){
            if(err) return res.status(500).json({error: err});
            if(books.length === 0) return res.status(404).json({error: 'book not found'});
            res.json(books);
        })
    });

    // CREATE BOOK
    app.post('/api/parkings', function(req, res){
        //var parking = new Parking();
        /*
        book.title = req.body.name;
        book.author = req.body.author;
        book.published_date = new Date(req.body.published_date);
        */

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
    app.put('/api/parkings/:book_id', function(req, res){
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

}