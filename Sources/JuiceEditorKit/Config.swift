import CloudKit
import OSLog
import SwiftData
import SwiftUI
import WebKit
import Foundation

struct Config {
    static var rootEmoji = "🖼️"
    
    private var fileManager = FileManager.default
    
    var sandboxPrivateKeyURL: URL {
        getRunnerDir().appending(component: "private_key")
    }
    
    static func makeLogger(_ category: String) -> Logger {
        Logger(subsystem: "JuiceEditorSwift", category: category)
    }
    
    func getDocumentsURL() -> URL {
        fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
    }
    
    func getKnownHostsURL() -> URL {
        getRunnerDir().appending(component: "known_hosts")
    }
    
    func getAppDir() -> URL {
        var isDir: ObjCBool = true
        let url = getDocumentsURL().appendingPathComponent(
            "Kuaiyizhi",
            isDirectory: true
        )
        
        if !fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
            do {
                try fileManager.createDirectory(
                    at: url,
                    withIntermediateDirectories: true
                )
            } catch (let error) {
                fatalError("创建 APP 目录失败：\(error.localizedDescription)")
            }
        }
        
        return url
    }
    
    func getTempDir() -> URL {
        var isDir: ObjCBool = true
        let url = getAppDir()
            .appendingPathComponent("temp", isDirectory: true)
        
        if !fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
            do {
                try fileManager.createDirectory(
                    at: url,
                    withIntermediateDirectories: true
                )
            } catch (let error) {
                fatalError("创建 TEMP 目录失败：\(error.localizedDescription)")
            }
        }

        return url
    }
    
    func getRunnerDir() -> URL {
        var isDir: ObjCBool = true
        let url = getAppDir()
            .appendingPathComponent("runner", isDirectory: true)
        
        if !fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
            do {
                try fileManager.createDirectory(
                    at: url,
                    withIntermediateDirectories: true
                )
            } catch (let error) {
                fatalError("创建 Runner 目录失败：\(error.localizedDescription)")
            }
        }

        return url
    }

    static var currentDirectoryPath = FileManager.default.currentDirectoryPath
    
    static var webAppPath: String = {
        let settingsURL = Bundle.module.url(forResource: "WebApp", withExtension: nil)

        if let settingsURL = settingsURL {
            return settingsURL.path(percentEncoded: false)
        }
        
        fatalError("WebApp directory not found")
    }()
}
