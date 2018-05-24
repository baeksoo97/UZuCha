// routes/index.js

module.exports = function(app, Parking, db)
{
    // GET ALL PARKINGS
    app.get('/api/parkings', function(req,res){
        Parking.find(function(err, parkings){
            if(err) return res.status(500).send({error: 'database failure'});
            res.json(parkings);
        })
    });

    // GET SINGLE PARKINGS
    // GET by ID
    app.get('/api/parkings/:book_id', function(req, res){
        Book.findOne({_id: req.params.book_id}, function(err, book){
            if(err) return res.status(500).json({error: err});
            if(!book) return res.status(404).json({error: 'book not found'});
            res.json(book);
        })
    });

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