import Vapor
import HTTP
import Foundation
import SwiftProtobuf


let drop = Droplet()

drop.post("/proto") {
    request in
    guard let bytes = request.body.bytes else {
        throw Abort.badRequest
    }
    let data = Data(bytes: bytes)
    do {
        let msgIn = try SimpleMessage(serializedData: data)
        print("Got message: \(msgIn.content)")
        let outString = String(msgIn.content.characters.reversed())
        var msgOut = SimpleMessage()
        msgOut.content = outString
        let outData = try msgOut.serializedData()
        var response = Response(body: try msgOut.serializedData())
        response.headers["content-type"] = "application/octet-stream"
        return response
    } catch {
        NSLog("Failed to process message: \(error.localizedDescription)")
        throw Abort.serverError
    }
}

drop.run()
