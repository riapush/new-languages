use tokio::net::{TcpListener, TcpStream};
use tokio::io::{AsyncReadExt, AsyncWriteExt};

#[tokio::main]
async fn main() {
    let listener = TcpListener::bind("127.0.0.1:8080").await.unwrap();
    println!("Listening on port 8080...");

    loop {
        let (mut stream, _) = listener.accept().await.unwrap();
        tokio::spawn(async move {
            handle_client(&mut stream).await;
        });
    }
}

async fn handle_client(stream: &mut TcpStream) {
    let mut buf = [0; 1024];
    let mut message = String::new();

    stream.write_all(b"\nWrite your message and press enter: ").await.unwrap();

    loop {
        match stream.read(&mut buf).await {
            Ok(n) => {
                if n == 0 {
                    return;
                }
                message.push_str(&String::from_utf8_lossy(&buf[..n]));

                if message.ends_with('\n') {
                    print!("Received message: {}", message);
                    stream.write_all(b"Message received
").await.unwrap();
                    stream.write_all(b"\nWrite your message and press enter: ").await.unwrap();
                    message.clear();
                }

                buf[..n].iter_mut().for_each(|b| *b = 0); // Clear the buffer
            }
            Err(e) => {
                println!("Error reading from socket: {}", e);
                return;
            }
        }
    }
}