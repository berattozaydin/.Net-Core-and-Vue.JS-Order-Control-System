export const createSocket = (path) => {
    const domainAddress = "localhost:5035"
    const publishAdress = ""
    var socket = new WebSocket(
        `ws://${domainAddress ? domainAddress : window.location.host}/ws/${path}`
    );
    socket.onerror = (e) => {
        console.log('e :>> ', e);
    };

    socket.onclose = (e) => { 
        console.log('e :>> ', e);
    };


    return socket;
};