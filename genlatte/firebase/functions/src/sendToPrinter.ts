import { onCall, HttpsError } from "firebase-functions/v2/https";
import sharp from 'sharp';
import { db } from "./common";
import { logger } from "firebase-functions";
const headers = {
    "Redacted": "headers",
};

async function sendUploadMessageCode(imageBufferRaw: Buffer, machineId: string, blackAndWhiteMachine: boolean = true) {
    try {
        const image = await sharp(imageBufferRaw)
            .resize(800, 800);

        if (blackAndWhiteMachine) {
            image.grayscale();
        }

        const imageBuffer = await image.jpeg().toBuffer();

        const base64Image = imageBuffer.toString('base64');

        const payload = `redacted`;

        const response = await fetch("redacted_url", {
            method: "POST",
            headers: {
                ...headers,
                "Content-Length": Buffer.byteLength(payload, 'utf8').toString()
            },
            body: payload
        });

        const data = await response.text();
        console.log("Response status:", response.status);
        console.log("Response data:", data);
    } catch (error) {
        console.error("Error sending request:", error);
    }
}

/**
 * Looks up a machine by name.
 * @param machineName The name of the machine to look up.
 * @returns The machine ID and whether it is a black and white machine.
 */
const machineLookupByName = async (machineName: string): Promise<{ id: string, isBlackAndWhite: boolean }> => {
    const machineRef = db.collection('machines').where('name', '==', machineName);
    const snapshot = await machineRef.get();
    if (snapshot.empty) {
        throw new HttpsError("not-found", "Machine not found.");
    }
    return { id: snapshot.docs[0].id, isBlackAndWhite: snapshot.docs[0].data().isBlackAndWhite };
}

/**
 * Sends an image to the printer.
 * @param imagePath The gs:// path to the image to send.
 */
export const sendToPrinter = onCall({ memory: "1GiB" }, async (request) => {
    logger.info("Request data:", JSON.stringify(request.data));
    let { imagePath, machineName } = request.data;

    if (!machineName || typeof machineName !== 'string') {
        machineName = "Barry White";
    }

    if (!imagePath || typeof imagePath !== 'string' || !imagePath.startsWith('https://')) {
        throw new HttpsError("invalid-argument", "The function must be called with a valid 'imagePath' string argument starting with 'https://'.");
    }

    const machine = await machineLookupByName(machineName);
    logger.info("Machine found:", JSON.stringify(machine));

    try {
        const url = new URL(imagePath);

        const imageBufferRaw = await fetch(url.toString()).then(res => res.arrayBuffer());

        const machineIdInt = parseInt(machine.id);
        const magicNumber = machineIdInt ^ 21937163;

        await sendUploadMessageCode(Buffer.from(imageBufferRaw), magicNumber.toString(), machine.isBlackAndWhite);
        return { success: true };
    } catch (e: any) {
        throw new HttpsError("internal", "An error occurred while sending the image to the printer.", e.message);
    }
});
