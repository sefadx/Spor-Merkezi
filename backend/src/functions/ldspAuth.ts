import ldap from "ldapjs";
import dotenv from "dotenv";

dotenv.config();

const LDAP_URL = process.env.LDAP_URL || "ldap://silivri.bel.tr";
const BASE_DN = process.env.BASE_DN || "dc=silivri,dc=bel.tr";

interface LdapAuthResult {
    success: boolean;
    message: string;
}
//flutter: API'den gelen veri: {"message":"Giriş başarılı!","token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjE0NTI4OTkzMTAyQHNpbGl2cmkuYmVsLnRyIiwiaWF0IjoxNzQwNzQzMjY1LCJleHAiOjE3NDA3NTA0NjV9.WmrUUfSNKizsSHHez1XxuvMb80yDdtwxXPH91fL2A6Q"}

export const authenticateUser = (username: string, password: string): Promise<LdapAuthResult> => {
    return new Promise((resolve) => {
        const client = ldap.createClient({ url: LDAP_URL });

        //const userDN = `cn=${username},${BASE_DN}`;
        const userDN = `${username}@silivri.bel.tr`;
        client.bind(userDN, password, (err) => {
            if (err) {
                console.error("LDAP Authentication Failed:", err);
                resolve({ success: false, message: "Kimlik doğrulama başarısız." });
            } else {
                console.log(`User ${username} authenticated successfully`);
                resolve({ success: true, message: "Giriş başarılı!" });
            }

            client.unbind();
        });
    });
};

/*
ldap.createClient ile LDAP sunucusuna bağlandık.
client.bind(userDN, password) ile kullanıcı doğrulaması yaptık.
Başarılı girişlerde { success: true, message: "Giriş başarılı!" } döndürdük.
Hatalı girişlerde { success: false, message: "Kimlik doğrulama başarısız." } döndürdük.
*/