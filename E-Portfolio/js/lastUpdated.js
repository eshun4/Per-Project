function lastModified(){
    var x = document.lastModified;
    let newDate = new Date(x);

    let options = {
        day: "numeric",
        month: "long",
        year: "numeric",
        weekday:"long"
    }
    var formatted_date = Intl.DateTimeFormat("en-US", options).format(newDate)
    document.write( formatted_date);
}

