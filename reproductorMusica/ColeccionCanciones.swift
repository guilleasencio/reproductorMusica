//
//  ColleccionCanciones.swift
//  reproductorMusica
//
//  Created by Guillermo Asencio Sanchez on 15/4/16.
//  Copyright © 2016 Guillermo Asencio Sanchez. All rights reserved.
//

import Foundation
import UIKit

class Cancion: NSObject {
    var nombre: String
    var autor: String
    var disco: String
    var nombreFichero: String
    var portada: UIImage
    
    init(nombre: String, autor: String, disco: String, portada: UIImage, nombreFichero:  String){
        
        self.nombre = nombre
        self.autor = autor
        self.disco = disco
        self.portada = portada
        self.nombreFichero = nombreFichero
    
    }
}

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<self.count-1
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}

class ColeccionCanciones {
    
    var canciones: Array<Cancion> = Array<Cancion>()
    
    init(){
        self.canciones.append(Cancion(nombre: "Cheese", autor: "David Szesztay", disco: "Needle Drop Co", portada: UIImage(named: "cheese")!, nombreFichero: "cheese"))
        self.canciones.append(Cancion(nombre: "Hachiko (The Faithful Dog)", autor: "The Kyoto Connection", disco: "Wake up", portada: UIImage(named: "hachiko")!, nombreFichero: "hachiko"))
        self.canciones.append(Cancion(nombre: "Happy Go Lucky", autor: "Scott Holmes", disco: "Music for TV & Film Vol. 1", portada: UIImage(named: "happy")!, nombreFichero: "happy"))
        self.canciones.append(Cancion(nombre: "Night Owl", autor: "Broke For Free", disco: "Directioless", portada: UIImage(named: "night")!, nombreFichero: "night"))
        self.canciones.append(Cancion(nombre: "Seeing the Future", autor: "Dexter Britain", disco: "Creative Commons Volume. 2", portada: UIImage(named: "future")!, nombreFichero: "future"))
        
        self.canciones.shuffle()
        
    }
}
