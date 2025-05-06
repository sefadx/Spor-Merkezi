import ldap from "ldapjs";
import dotenv from "dotenv";

dotenv.config();

const LDAP_URL = process.env.LDAP_URL || "ldap://link.ex.ct";
const BASE_DN = process.env.BASE_DN || "dc=link,dc=ex.ct";

interface LdapAuthResult {
    success: boolean;
    message: string;
}

export const authenticateUser = (username: string, password: string): Promise<LdapAuthResult> => {
    return new Promise((resolve) => {
        const client = ldap.createClient({ url: LDAP_URL });

        //const userDN = `cn=${username},${BASE_DN}`;
        const userDN = `${username}@link.ex.ct`;
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