//
//  ViewController.swift
//  reproductorMusica
//
//  Created by Guillermo Asencio Sanchez on 14/4/16.
//  Copyright © 2016 Guillermo Asencio Sanchez. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var cancionPicker: UIPickerView!
    @IBOutlet weak var portada: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    private var reproductor: AVAudioPlayer!
    
    @IBOutlet weak var volumenSlider: UISlider!
    
    
    let coleccionCanciones: ColeccionCanciones = ColeccionCanciones()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cancionPicker.selectRow(0, inComponent: 0, animated: false)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func siguienteCancion() {
        
        self.stop()
        
        let proximaCancion = (self.cancionPicker.selectedRowInComponent(0) + 1) % self.coleccionCanciones.canciones.count
        self.cancionPicker.selectRow(proximaCancion, inComponent: 0, animated: true)
        
        self.portada.image = self.coleccionCanciones.canciones[proximaCancion].portada
        
        let sonidoURL = NSBundle.mainBundle().URLForResource(self.coleccionCanciones.canciones[proximaCancion].nombreFichero, withExtension: "mp3")
        
        do{
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            reproductor.volume = self.volumenSlider.value
            
            self.play()

            self.reproductor.delegate = self
        }catch{
            print("Error al cargar el archivo de sonido")
        }


        
    }
    
    @IBAction func cancionAnterior() {
        
       
        self.stop()
        
        var proximaCancion = (self.cancionPicker.selectedRowInComponent(0) - 1) % self.coleccionCanciones.canciones.count
        
        if proximaCancion < 0{
            proximaCancion += self.coleccionCanciones.canciones.count
        }
        
        self.cancionPicker.selectRow(proximaCancion, inComponent: 0, animated: true)
        
        self.portada.image = self.coleccionCanciones.canciones[proximaCancion].portada
        
        let sonidoURL = NSBundle.mainBundle().URLForResource(self.coleccionCanciones.canciones[proximaCancion].nombreFichero, withExtension: "mp3")
        
        do{
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            reproductor.volume = self.volumenSlider.value
            
            self.play()
            
            self.reproductor.delegate = self
        }catch{
            print("Error al cargar el archivo de sonido")
        }

    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        let indice = self.cancionPicker.selectedRowInComponent(0)
        
        self.portada.image = self.coleccionCanciones.canciones[indice].portada
        
        let sonidoURL = NSBundle.mainBundle().URLForResource(self.coleccionCanciones.canciones[indice].nombreFichero, withExtension: "mp3")
        do{
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            self.reproductor.delegate = self
        }catch{
            print("Error al cargar el archivo de sonido")
        }
        self.playButton.hidden = false
        self.pauseButton.hidden = true
        
        self.volumenSlider.value = reproductor.volume

        
    }
    @IBAction func controlarVolumen(sender: UISlider) {
        reproductor.volume = sender.value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Funcion requerida para en la utilización de UIPickerViewDataSource: indica el numero de columnas que contendrá el Picker View
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Funcion requerida para en la utilización de UIPickerViewDataSource: indica el numero de filas que contendrá un componente específico del Picker View
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.coleccionCanciones.canciones.count
    }
    
    // Funcion requerida para en la utilización de UIPickerViewDataSource: indica el texto que contendrá cada fila del Picker View
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
       
        return self.coleccionCanciones.canciones[row].nombre
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.stop()
        self.portada.image = self.coleccionCanciones.canciones[row].portada
        
        let sonidoURL = NSBundle.mainBundle().URLForResource(self.coleccionCanciones.canciones[row].nombreFichero, withExtension: "mp3")
        do{
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            reproductor.volume = self.volumenSlider.value
            self.play()
            self.reproductor.delegate = self
        }catch{
            print("Error al cargar el archivo de sonido")
        }

    }
    
    @IBAction func play() {
        
        if !reproductor.playing{
            reproductor.play()
            self.playButton.hidden = true
            self.pauseButton.hidden = false
        }
    }
    
    @IBAction func pausar() {
        if reproductor.playing{
            reproductor.pause()
            self.playButton.hidden = false
            self.pauseButton.hidden = true
        }
    }


    @IBAction func stop() {
        if reproductor.playing{
            reproductor.stop()
            reproductor.currentTime = 0
            self.playButton.hidden = false
            self.pauseButton.hidden = true
        }

    }
    
    @IBAction func ordenarAleatorio() {
        self.stop()
        self.coleccionCanciones.canciones.shuffle()
        self.cancionPicker.reloadComponent(0)
        self.cancionPicker.selectRow(0, inComponent: 0, animated: true)
        
        self.portada.image = self.coleccionCanciones.canciones[0].portada
        
        let sonidoURL = NSBundle.mainBundle().URLForResource(self.coleccionCanciones.canciones[0].nombreFichero, withExtension: "mp3")
        
        do{
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            reproductor.volume = self.volumenSlider.value
            self.play()
            self.reproductor.delegate = self
        }catch{
            print("Error al cargar el archivo de sonido")
        }
        

    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully
        flag: Bool) {
        
        self.stop()
        if(self.cancionPicker.selectedRowInComponent(0)<self.coleccionCanciones.canciones.count-1){
            let proximaCancion = self.cancionPicker.selectedRowInComponent(0) + 1
            self.cancionPicker.selectRow(proximaCancion, inComponent: 0, animated: true)
            
            self.portada.image = self.coleccionCanciones.canciones[proximaCancion].portada
            
            let sonidoURL = NSBundle.mainBundle().URLForResource(self.coleccionCanciones.canciones[proximaCancion].nombreFichero, withExtension: "mp3")
            
            do{
                try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
                reproductor.volume = self.volumenSlider.value
                self.play()
                self.reproductor.delegate = self
            }catch{
                print("Error al cargar el archivo de sonido")
            }

        }else{
            self.playButton.hidden = false
            self.pauseButton.hidden = true
        }
    }

}

