//
//  APIManager.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 01.06.23.
//

import Foundation

enum RegistrationError: Error {
    case invalidURL
    case encodingError
    case networkError
    case httpError
    case invalidResponse
    case parsingError
    case noData
}

enum RegistrationResult {
    case success
    case failure(RegistrationError)
}

class APIManager: ObservableObject {
    
    static let shared = APIManager() // Singleton-Instanz des APIManagers
    
    public let logging: (String) -> Void = { message in
        
        var logString = "APICall: \(message)"
        
        Logger.shared.log(message: logString)
        
    }
    
    
    //TODO: checkUsername(), checkMail() und authUser() zu GET umschreiben!
    
    //MARK: registerUser()
    //is working
    func registerUser(username: String, password: String, email: String, completion: @escaping (Bool, String) -> Void) {
        
        
        logging("APP-Call wurde aufgerufen")
        
        //Erstellen und umwanden der URL
        let urlString = "https://testapi.mediba.me/reg.php"
        
        guard let url = URL(string: urlString) else {
            logging("Ungültige URL: \(urlString)")
            completion(false, "Ungültige URL: '\(urlString)'")
            return
        }
        /*
         URL(string: ) prüft, ob die angegebene URL (urlString) das richtige Format hat,
         wenn nicht, wir versucht es ins richige Format zu bringen:
         - Validierung der URL-Struktur: Die URL-Initialisierung überprüft, ob die übergebene Zeichenkette
         die grundlegenden Anforderungen an eine URL erfüllt. Dies umfasst das Vorhandensein eines
         gültigen Protokolls (z. B. "http://" oder "https://") und die korrekte Formatierung der Domäne,
         des Pfads und der optionalen Query-Parameter.
         
         - Encoding von Sonderzeichen: Wenn der urlString Sonderzeichen enthält, die in einer URL nicht
         zulässig sind (z. B. Leerzeichen oder bestimmte Sonderzeichen), werden diese automatisch
         URL-codiert. Das bedeutet, dass sie in ein spezielles Format umgewandelt werden, um als Teil
         der URL akzeptiert zu werden.
         
         - Normalisierung der URL: Die URL-Initialisierung führt auch eine Normalisierung der URL durch.
         Das bedeutet, dass Doppelungen oder unnötige Teile entfernt werden, um eine einheitliche
         Darstellung der URL zu gewährleisten. Zum Beispiel werden überflüssige Schrägstriche oder
         Punkt- und Strichpunkt-Zeichen entfernt.
         */
        
        //Instanz von URLRequest wird erstellt
        var request = URLRequest(url: url)
        
        //httpMethode wird der Instanz übergeben
        request.httpMethod = "POST"
        
        
        
        // der Http-Header-Field "Conten-Type" erhält den Wert "application/x-www-form-urlencoded"
        //"application/x-www-form-urlencoded -> Daten sind im URL-Format codiert
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        /*
         Ein URLRequest-Objekt repräsentiert eine URL-Anforderung, die an einen Server gesendet
         werden soll. Es enthält Informationen wie die URL, die HTTP-Methode (GET, POST, usw.),
         Header-Felder und den HTTP-Körper (bei POST-Anfragen).
         
         Die URLRequest-Initialisierung verwendet die übergebene URL, um das Ziel der Anfrage festzulegen.
         Dadurch wird die URL in das Anfrageobjekt eingebettet, damit es später an den Server gesendet werden kann.
         */
        
        
        
        //Benutzername, Passwort und E-Mail als Übergabe-Parameter anlegen
        let parameters = ["username": username, "password": password, "email": email]
        
        do{
            //überprüfen, ob die Parameter im JSON-Format vorliegen/ins JSON-Format bringen
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            //Parameter dem httpBody übergeben
            request.httpBody = jsonData
            
            guard let postData = String(data: jsonData, encoding: .utf8) else {
                logging("Fehler bei Konvertierung der Paramameter zu UTF-8")
                completion(false, "Fehler bei Konvertierung der Paramameter zu UTF-8")
                return
            }
            
            logging("POST-Daten: \(postData)")
            
        } catch {
            
            logging("Fehler bei Konvertierung der Parameter ins JSON-Format: \(error.localizedDescription)")
            
            return
            
        }
        
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            self.logging("API-Call wurde ausgeführt.")
            
            if let error = error {
                
                completion(false, "API-Call konnte nicht ausgeführt werden: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                
                //Wenn Statusode nicht zwischen 200 und 299 liegt, liegt ein Fehler seitens der
                //API vor
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                
                self.logging("API gibt Fehlercode \(statusCode) zurück")
                completion(false, "Statuscode: \(statusCode)")
                return
                
            }
            
            if let data = data {
                
                self.logging("(1/3) Server hat Daten übermittelt.")
                self.logging("(2/3) Daten: \(data)")
                
                if let dataString = String(data: data, encoding: .utf8) {
                    
                    self.logging("(3/3) Empfangene Daten: \(dataString)")
                    
                } else {
                    
                    self.logging("Daten liegen nicht im UTF-Format vor")
                    completion(false, "Daten liegen nicht im UTF-Format vor")
                    return
                    
                    
                }
                
                do {
                    
                    //Daten aus dem JSON-Object extrahieren
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let registrated = json["registrated"] as? Bool,
                       let apitoken = json["apitoken"] as? String {
                        
                        self.logging("JSON-Daten wurden extrahiert.")
                        
                        //Damit die Completion-Closure im HauptThread ausgeführt wird
                        DispatchQueue.main.async {
                            completion(registrated, apitoken)
                        }
                        
                    }
                    
                } catch {
                    
                    self.logging("JSON-Daten wurden nicht extrahiert.")
                    
                    completion(false, error.localizedDescription)
                }
            } else {
                
                self.logging("Server hat keine Daten übermittelt.")
                
                DispatchQueue.main.async {
                    completion(false, "Keine Daten empfangen.")
                }
                
            }
        }
        
        task.resume()
    }
    
    //MARK: checkUsername()
    //is working
    func checkUsername(username: String, completion: @escaping (Bool, String) -> Void) {
        //Ausgabe zum Debuggen:
        logging("Funktion checkUsername() wurde aufgerufen")
        
        // API-URL definieren
        let urlString = "https://testapi.mediba.me/checkUsername.php"
        
        // API-URL prüfen
        guard let url = URL(string: urlString) else {
            
            logging("Ungültige URL: \(urlString)")
            
            completion(false, "Ungültige URL: \(urlString)")
            
            return
            
        }
        //Ausgabe zum Debuggen:
        logging("URL wurde in das richtige Format umgewandelt")
        
        //Instanz von URLRequest wird erstellt
        var request = URLRequest(url: url)
        
        //httpMethode wird der Instanz übergeben
        request.httpMethod = "POST"
        
        //Benutzernamen als JSON-Daten im HTTP-Body senden
        let parameters = ["username": username]
        
        //Ausgabe zum Debuggen:
        logging("Übergebener Username:\(username)")
        
        //httpBody wird der Instanz übergeben
        //request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            //Parameter dem httpBody übergeben
            request.httpBody = jsonData
            
            
            guard let postData = String(data: jsonData, encoding: .utf8) else {
                logging("Fehler bei der Konvertierung der Parameter in einen String")
                completion(false, "Fehler bei der Konvertierung der Parameter")
                return
            }
            
            // Debug-Ausgabe
            logging("POST-Daten: \(postData)")
            
        } catch {
            
            logging("Fehler bei der Konvertierung der Parameter: \(error.localizedDescription)")
            
            completion(false, error.localizedDescription)
            
            return
            
        }
        
        
        
        // Singleton-Instanz von URLSession erstellen
        let session = URLSession.shared
        
        //Datenaufgabe erstellen (die bei task.resume() rausgeführt wird)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            //Ausgabe zum Debuggen:
            self.logging("API-Call wurde durchgeführt")
            
            // Fehler überprüfen
            if let error = error {
                
                //Ausgabe zum Debuggen:
                self.logging("API hat einen Fehler zurück gegeben:  \(error.localizedDescription)")
                
                completion(false, error.localizedDescription)
                
                return
                
            }
            
            // es wird überprüft, ob daten übermittelt wurden
            if let data = data {
                
                //Ausgaben zum Debuggen:
                self.logging("(1/3) API hat Daten übergeben")
                self.logging("(2/3): Meldung: \(data))")
                
                
                if let dataString = String(data: data, encoding: .utf8) {
                    self.logging("(3/3: Empfangene Daten: \(dataString)")
                }
                
                //Wenn Daten übermittelt wurden
                do {
                    
                    self.logging("die do{}catch{} wird betreten: do{}")
                    
                    //werden die Daten aus dem JSON-Objekt extrahiert
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        //Es wird geschaut, ob die Antwort in ein NSDictionary oder NSArray gespeichert werden
                        //kann passiert automatish durch die JSONSerialization
                        
                        //extrahierte Daten werden in Variablen gespeichert und dann die
                        //Completion-Closure der checkEmail-Funktion weiter gegeben.
                        if let exists = json["exists"] as? Bool,
                           let message = json["message"] as? String {
                            
                            
                            //Ausgabe zum Debuggen
                            self.logging("JSON-Daten wurden extrahiert.")
                            
                            completion(exists, message)
                            
                            return
                            
                        } else {
                            
                            //Ausgabe zum Debuggen:
                            self.logging("Ungültige Daten erhalten.")
                            
                            completion(false, "Ungültige Daten erhalten")
                            
                            return
                            
                        }
                    } else {
                        
                        //Ausgabe zum Debuggen:
                        self.logging("Ungültige Daten erhalten.")
                        
                        completion(false, "Ungültige Daten erhalten")
                        
                        return
                        
                    }
                    
                } catch {
                    //Wenn es einen Fehler bei der Extrahierung der Daten gibt, wird der Fehler
                    //an die Completion-Closure der checkEmail-Funktion weiter gegeben.
                    
                    //Ausgabe zum Debuggen:
                    self.logging("JSON-Daten wurden nicht extrahiert: \(error.localizedDescription)")
                    
                    
                    completion(false, error.localizedDescription)
                    
                    return
                }
            }else{
                
                //Ausgabe zum Debuggen:
                self.logging("API hat keine Daten übergeben")
                
                //Wenn keine Daten übermittelt wurden, wird das an die Completion-Closure der
                //checkEmail-Funktion weiter geben, zusammen mit einer Beschreibung des
                //Fehlers ("Keine Daten Empfangen").
                completion(false, "Keine Daten Empfangen")
                
                
            }
        }
        //API-Call starten
        task.resume()
    }
    
    //MARK: checkMail()
    //isworking
    func checkMail(mail: String, completion: @escaping (Bool, String) -> Void) {
        
        //Ausgabe zum Debuggen:
        logging("Funktion checkMail() wurde aufgerufen")
        
        // API-URL definieren
        let urlString = "https://testapi.mediba.me/checkEmail.php"
        
        
        //Falls die URL nicht ins richtige  Format umgewandelt werden kann, wird ein Fehler (false) angeben und
        //eine Beschreibung des Fehlers ("Ungültige URL"), danach wir die gesamte checkEmail-Funktion verlassen
        //(return)
        guard let url = URL(string: urlString) else {
            completion(false, "Ungültige URL")
            return
        }
        //Ausgabe zum Debuggen:
        logging("URL wurde in das richtige Format umgewandelt")
        
        /*
         URL(string: ) prüft, ob die angegebene URL (urlString) das richtige Format hat,
         wenn nicht, wir versucht es ins richige Format zu bringen:
         - Validierung der URL-Struktur: Die URL-Initialisierung überprüft, ob die übergebene Zeichenkette
         die grundlegenden Anforderungen an eine URL erfüllt. Dies umfasst das Vorhandensein eines
         gültigen Protokolls (z. B. "http://" oder "https://"!!!Achtung, standartmäßig wird nur https
         zugelassen, andersfalls muss die Info.plist geändert werden!!!) und die korrekte Formatierung der
         Domäne, des Pfads und der optionalen Query-Parameter.
         
         - Encoding von Sonderzeichen: Wenn der urlString Sonderzeichen enthält, die in einer URL nicht
         zulässig sind (z. B. Leerzeichen oder bestimmte Sonderzeichen), werden diese automatisch
         URL-codiert. Das bedeutet, dass sie in ein spezielles Format umgewandelt werden, um als Teil
         der URL akzeptiert zu werden.
         
         - Normalisierung der URL: Die URL-Initialisierung führt auch eine Normalisierung der URL durch.
         Das bedeutet, dass Doppelungen oder unnötige Teile entfernt werden, um eine einheitliche
         Darstellung der URL zu gewährleisten. Zum Beispiel werden überflüssige Schrägstriche oder
         Punkt- und Strichpunkt-Zeichen entfernt.
         */
        
        //Instanz von URLRequest wird erstellt
        var request = URLRequest(url: url)
        
        //Ausgabe zum Debuggen:
        
        //httpMethode wird der Instanz übergeben
        request.httpMethod = "POST"
        /*
         Mögliche Methoden:
         GET:       Die GET-Methode wird verwendet, um eine Ressource vom Server abzurufen. Sie wird verwendet,
         wenn der Client Daten vom Server anfordert. GET-Anfragen sollten idempotent sein, was
         bedeutet, dass sie keine Auswirkungen auf die Ressource haben sollten.
         
         POST:      Die POST-Methode wird verwendet, um Daten an den Server zu senden und eine neue Ressource zu
         erstellen. POST-Anfragen werden normalerweise verwendet, wenn der Client Daten an den Server
         sendet, um sie zu verarbeiten oder in der Datenbank zu speichern.
         
         PUT:       Die PUT-Methode wird verwendet, um eine vorhandene Ressource zu aktualisieren oder zu
         ersetzen. Der Client sendet die vollständige Darstellung der Ressource an den Server, und
         dieser aktualisiert die Ressource entsprechend.
         
         PATCH:     Die PATCH-Methode wird verwendet, um eine vorhandene Ressource teilweise zu aktualisieren. Im
         Gegensatz zu PUT sendet der Client nur die geänderten Teile der Ressource an den Server.
         
         DELETE:    Die DELETE-Methode wird verwendet, um eine Ressource vom Server zu löschen.
         
         HEAD:      Die HEAD-Methode ähnelt der GET-Methode, gibt jedoch nur die Header-Informationen der
         Ressource zurück, nicht den eigentlichen Inhalt.
         
         OPTIONS:   Die OPTIONS-Methode wird verwendet, um die vom Server unterstützten Methoden und Optionen für
         eine Ressource abzurufen.
         */
        
        // E-Mail als Paramter zum Übergeben speichern.
        let parameters = ["mail": mail]
        /*
         Falls mehrere Daten gesendet werden, müssen die Datenpaare (Dictionarys) mit komma getrennt übergeben
         werden:
         let parameters = [
         "username": username,
         "password": password,
         "email": email
         ]
         Eine generelle Begrenzung der Anzahl der Parameter gibt es nicht und wird von der API vorgegeben.
         -> API-Dokumentation lesen um zu wissen, welche Parameter verlangt werden.
         */
        
        //Ausgabe zum Debuggen:
        logging("Übergebene E-Mail-Adresse:\(mail)")
        
        //Erst wird überprüft, ob die Parameter im JSON-Format vorleigen, wenn nicht, wird versuchtm suie ub das
        //Format zu konvertieren
        //Die erstellten Paramater werden dem httpBody übergeben, ohne Optionen hinzu.
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            //Parameter dem httpBody übergeben
            request.httpBody = jsonData
            
            
            //jsonDaten werden in eine Zeichenkette im UTF-8Format konvertiert.
            //er Codeausschnitt "guard let postData = String(data: jsonData, encoding: .utf8)"
            //versucht, die JSON-Daten in Form einer Zeichenkette (String) zu konvertieren.
            //Hierbei wird die Methode String(data:encoding:) verwendet, um die Binärdaten
            //(jsonData) in eine Zeichenkette zu decodieren, wobei das
            //UTF-8-Zeichenkodierungsschema verwendet wird
            //Die Variable postData enthält dann die Zeichenkettendarstellung der jsonData-Daten
            //im UTF-8-Format, die für weitere Verwendungszwecke genutzt werden kann, wie zum
            //Beispiel für das Logging oder den Versand an einen Server.
            guard let postData = String(data: jsonData, encoding: .utf8) else {
                
                self.logging("Fehler bei der Konvertierung der Parameter in einen String")
                
                completion(false, "Fehler bei der Konvertierung der Parameter")
                
                return
            }
            
            // Debug-Ausgabe
            logging("POST-Daten: \(postData)")
            
        } catch {
            logging("Fehler bei der Konvertierung der Parameter: \(error.localizedDescription)")
            
            completion(false, error.localizedDescription)
            
            return
            
        }
        /*
         möglichen Optionen sind:
         
         - .fragmentsAllowed:       Erlaubt das Konvertieren von JSON-Fragmenten, wie einzelnen Werten,
         anstelle eines vollständigen JSON-Objekts oder -Arrays.
         - .sortedKeys:             Sortiert die Schlüssel im generierten JSON alphabetisch.
         - .prettyPrinted:          Fügt zusätzliche Leerraum- und Einzüge hinzu, um das generierte JSON
         lesbarer zu machen.
         - .withoutEscapingSlashes: Deaktiviert das Escapen von Schrägstrichen ("/") im generierten JSON.
         - .writingOptions:         Eine Reihe von Schreiboptionen, die die JSON-Ausgabe anpassen können.
         Zum Beispiel:
         - .sortedKeys:             Sortiert die Schlüssel im generierten JSON
         alphabetisch.
         - .prettyPrinted:          Fügt zusätzliche Leerraum- und Einzüge hinzu, um
         das generierte JSON lesbarer zu machen.
         - .fragmentsAllowed:       Erlaubt das Konvertieren von Fragmenten.
         - .withoutEscapingSlashes: Deaktiviert das Escapen von Schrägstrichen ("/").
         - .readingOptions:         Eine Reihe von Lesemöglichkeiten für die JSON-Eingabe.
         Zum Beispiel:
         - .mutableContainers:       Erstellt mutable (veränderbare) Container für
         JSON-Objekte und -Arrays anstelle von
         unveränderlichen (immutable) Versionen.
         - .mutableLeaves:           Erstellt mutable (veränderbare) Blätter für
         JSON-Werte anstelle von unveränderlichen
         (immutable) Versionen.
         - .allowFragments:          Erlaubt das Parsen von JSON-Fragmenten.
         Beispiel, wenn Optionen übergeben werden:
         JSONSerialization.data(withJSONObject: parameters, options: [.sortedKeys, .prettyPrinted])
         */
        
        // Singleton-Instanz von URLSession erstellen
        let session = URLSession.shared
        /*
         Eine Singleton-Instanz ist ein Designmuster in der Softwareentwicklung, das
         sicherstellt, dass von einer bestimmten Klasse nur eine einzige Instanz
         existiert und auf diese global zugegriffen werden kann.
         */
        
        //erstellt eine Datenaufgabe (dataTask) mit der gegebenen URL-Anfrage (request)
        //im Anschluss wird die Completion-Handler-Closure mit (data, response und error) aufgerufen um die
        //Antworten vom Server auszuwerten
        //Datenaufgabe erstellen (die bei task.resume() rausgeführt wird)
        let task = session.dataTask(with: request) { (data, response, error) in
            //Ausgabe zum Debuggen:
            self.logging("API-Call wurde durchgeführt")
            
            //Wenn error = 'nil' gab es keine Fehler
            //Wenn error einen Wert enthält, gab es einen Fehler, den wir an die Completion-Closure der
            //checkEmail-Funktion weiter geben, zusammen mit einer Beschreibung des
            //Fehlers (error.localizedDescription).
            if let error = error {
                
                //Ausgabe zum Debuggen:
                self.logging("API hat einen Fehler zurück gegeben:  \(error.localizedDescription)")
                
                completion(false, error.localizedDescription)
                
                return
                
            }
            
            // es wird überprüft, ob daten übermittelt wurden
            if let data = data {
                
                //Ausgabe zum Debuggen:
                self.logging("(1/3):API hat Daten übergeben")
                self.logging("(2/3): Meldung: \(data))")
                
                //Prüfen, ob Antwort im UTF-8-Format erhalten wurde
                if let dataString = String(data: data, encoding: .utf8) {
                    self.logging("(3/3: Empfangene Daten: \(dataString)")
                }
                
                
                
                
                do {
                    
                    //Ausgabe zum Debuggen:
                    self.logging("die do{}catch{} wird betreten: do{}")
                    
                    // werden die Daten aus dem JSON-Objekt extrahiert
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       //Es wird geschaut, ob die Antwort in ein NSDictionary oder NSArray gespeichert werden
                       //passiert automatish durch die JSONSerialization
                        
                        //extrahierte Daten werden in Variablen gespeichert und dann die
                        //Completion-Closure der checkEmail-Funktion weiter gegeben.
                        let eexists = json["exists"] as? Bool,
                       let emessage = json["message"] as? String {
                        
                        //Ausgabe zum Debuggen:
                        self.logging("JSON-Daten wurden extrahiert")
                        
                        completion(eexists, emessage)
                        
                        return
                        
                    }
                } catch {
                    
                    //Ausgabe zum Debuggen:
                    print("APICall:JSON-Daten wurden nicht extrahiert: \(error.localizedDescription)")
                    
                    //Wenn es einen Fehler bei der Extrahierung der Daten gibt, wird der Fehler
                    //an die Completion-Closure der checkEmail-Funktion weiter gegeben.
                    completion(false, error.localizedDescription)
                    
                    
                }
            }else{
                
                //Ausgabe zum Debuggen
                self.logging("API at keine Daten übergeben!")
                
                //Wenn keine Daten übermittelt wurden, wird das an die Completion-Closure der
                //checkEmail-Funktion weiter geben, zusammen mit einer Beschreibung des
                //Fehlers ("Keine Daten Empfangen").
                completion(false, "Keine Daten Empfangen")
                
                return
                
            }
        }
        //Datenaufgabe ausführen
        task.resume()
    }
    
    //MARK: authUser()
    //isworking
    func authUser(username: String, password: String, completion: @escaping(Bool, String) -> Void){
        
        logging("API-Call wurde aufgerufen.")
        
        //API-Endpunkt festlegen
        let urlString = "https://testapi.mediba.me/authUser.php"
        
        //URL-Format prüfen
        guard let url = URL(string: urlString) else {
            logging("Ungültige URL:\(urlString)")
            completion(false, "Ungültige URL: '\(urlString)'")
            return
        }
        
        //Instanz von URLRequest erstellen
        var request = URLRequest(url: url)
        
        //httpMethode der Instanz übergeben
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //Benutzernamen und Passwort als Parameter anlegen
        let parameters = ["username": username, "password": password]
        
        do{
            //überprüfen, ob die Parameter im JSON-Format vorliegen/ins JSON-Format bringen
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            //Parameter dem httpBody übergeben
            request.httpBody = jsonData
            
            // die Data-Intanz (jsonData) in einen UTF8-String konvertieren
            guard let postData = String(data: jsonData, encoding: .utf8) else {
                logging("Fehler bei der Konvertierung in UTF8 der Parameter.")
                completion(false, "Fehler bei der Parameter-Konvertierung in UTF8")
                return
            }
            
            logging("POST-Daten: \(postData)")
            
        } catch {
            
            logging("Fehler bei der Konvertierung der Parameter ins JSON-Format: \(error.localizedDescription)")
            
            completion(false, error.localizedDescription)
            
            return
            
        }
        
        //Singleton-Instanz von URLSession aurufen
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            self.logging("API-Call wurde ausführt.")
            
            
            //Falls ein Error gesendet wurde
            if let error = error {
                
                self.logging("Server hat einen Fehler zurück gegeben: \(error.localizedDescription)")
                
                return
                
            }
            
            //Falls ein StatusCode/Fehlercode gesendet wurde
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                
                
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                
                self.logging("API gibt Fehlercode: \(statusCode) zurück")
                
                completion(false, "Statuscode: \(statusCode)")
                return
            }
            
            //Wenn Daten gesendet wurden
            //Warum kein Guard???
            if let data = data {
                
                self.logging("(1/3) Server hat Daten übermittelt.")
                self.logging("(2/3) Daten: \(data)")
                
                //Prüfen, ob Antwort im UTF-8-Format erhalten wurde
                if let dataString = String(data: data, encoding: .utf8) {
                    
                    self.logging("(3/3) Empfangene Daten: \(dataString)")
                    
                }
                
                do{
                    
                    //Daten aus dem JSON-Object extrahieren
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       
                        let verify = json["verify"] as? Bool,
                       let apitoken = json["apitoken"] as? String {
                        
                        self.logging("JSON-Daten wurden extrahiert.")
                        
                        completion(verify, apitoken)
                        
                    }
                    
                    
                } catch {
                    
                    self.logging("JSON-Daten wurden nicht extrahiert.")
                    
                    completion(false, error.localizedDescription)
                }
                
            } else {
                
                self.logging("Server hat keine Daten übermittelt.")
                
                completion(false, "Keine Daten empfangen.")
                
            }
            
        }
        
        task.resume()
        
    }
    
    //MARK: FalseApiCall
    //um Funktionsaufrufe und Antworten/Abhandlungen zu prüfen
    func apicallfalse(username: String, password: String, email: String, completion: @escaping (Bool, String) -> Void) {
        print("checkfunccall wurde aufgerufen")
        let message = "Die Funktion wurde aufgerufen und gibt false zurück!"
        completion(false, message)
    }
    
    //MARK: TrueApiCall
    //um Funktionsaufrufe und Antworten/Abhandlungen zu prüfen
    func apicalltrue(username: String, password: String, email: String, completion: @escaping (Bool, String) -> Void) {
        print("checkfunccall wurde aufgerufen")
        let message = "Die Funktion wurde aufgerufen und gibt true zurück!"
        completion(true, message)
    }
    
    //MARK: getTraining
    func getTraining(username: String, apiToken: String, completion: @escaping(Bool, String, [Training]) -> Void) {
        logging("getTraining API-Call wurde aufgerufen.")
        
        let urlString = "http://testapi.mediba.me/getTraining.php"
        
        guard let url = URL(string: urlString) else {
            logging("Ungültige URL: \(urlString)")
            completion(false, "Ungültige URL: '\(urlString)'", [])
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = ["username": username, "apiToken": apiToken]
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            request.httpBody = jsonData
            
            guard let postData = String(data: jsonData, encoding: .utf8) else {
                logging("Fehler bei der Konvertierung der Parameter zu UTF8.")
                completion(false, "Fehler bei der Konvertierung der Parameter zu UTF8.", [])
                return
            }
            
            logging("POST-Daten: \(postData)")
            
        } catch {
            
            logging("Fehler bei der Konvertierung der Parameter ins JSON-Format: \(error.localizedDescription)")
            
            completion(false, error.localizedDescription, [])
            
            return
            
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            self.logging("getTraining-Call wurde ausgeführt.")
            
            if let error = error {
                self.logging("Server hat einen Fehler zurück gegeben: \(error.localizedDescription)")
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                self.logging("API gibt Fehlercode: \(statusCode) zurück")
                
                completion(false, "Statuscode: \(statusCode)", [])
                
                return
            }
            
            if let data = data {
                
                self.logging("(1/3) Server hat Daten übermittelt.")
                self.logging("(2/3) Datensätze: \(data.count)")
                
                if let dataString = String(data: data, encoding: .utf8) {
                    self.logging("(3/3) Empfangende Datan: \(dataString)")
                }
                
                do{
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       
                        let success = json["success"] as? Bool,
                        let error = json["error"] as? String,
                       let training = json["training"] as? [Training] {
                        self.logging("JSON-Daten wurden extrahiert")
                        
                        completion(success, error, training)
                    }
                    
                } catch {
                    
                    self.logging("JSON-Daten wurden nich extrahiert.")
                    
                    completion(false, error.localizedDescription, [])
                    
                }
            } else {
                
                self.logging("Server hat keine Daten übermittelt.")
                
                completion(false, "Keine Daten empfangen", [])
                
            }
        }
        task.resume()
    }
    
}
