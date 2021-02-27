function tempo(request, response){
    const dinamicDate = new Date();

    response.json({
        date: dinamicDate.toGMTString()
    });
}

export default tempo;