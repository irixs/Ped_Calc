//
//  ViewController.swift
//  PedCalc
//
//  Created by Íris Soares on 02/03/20.
//  Copyright © 2020 Íris Soares. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBAction func verDosagem() {verDosagemButtom()}
    @IBAction func concluido() {concluidoButtom()}
    @IBAction func medicamentoEdit(_ sender: Any) {
        medicamentoTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        erroMedicamento.isHidden = true
    }
    @IBAction func dataEdit(_ sender: UITextField) {
        dataTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        erroData.isHidden = true;
    }
    @IBAction func pesoEdit(_ sender: UITextField) {
        pesoTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        erroPeso.isHidden = true;
    }
    @IBOutlet weak var medicamentoTextField: UITextField!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet var pesoTextField: UITextField!
    @IBOutlet var medicamento: UILabel!
    @IBOutlet var dosagem: UITextView!
    @IBOutlet var resultado1: UILabel!
    @IBOutlet var resultado2: UILabel!
    @IBOutlet var resultado3: UILabel!
    @IBOutlet var viewDados: UIView!
    @IBOutlet var viewDosagem: UIView!
    @IBOutlet var erroMedicamento: UILabel!
    @IBOutlet var erroData: UILabel!
    @IBOutlet var erroPeso: UILabel!
    var medicamentoPicker = UIPickerView()
    var dataPicker = UIDatePicker()
    let medicamentos = ["", "Dipirona"/*, "Paracetamol", "Amoxicilina", "Azitromicina", "Penicilina Benzatina (Benzetacil)", "Dexclorfeniramina"*/]
    
    //Infelizmente o licativo só vai ter um medicamento porque documentacao de remedio é obra do demonio e eu nao aguento mais passar raiva
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medicamentoPicker.delegate = self
        medicamentoPicker.dataSource = self
        medicamentoTextField.inputView = medicamentoPicker
        
        dataPicker.datePickerMode = UIDatePicker.Mode.date
        dataPicker.addTarget(self, action: #selector(ViewController.mudouData(sender:)), for: UIControl.Event.valueChanged)
        dataPicker.maximumDate = Date()
        dataTextField.inputView = dataPicker
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //---------------- PickerView -----------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return medicamentos.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return medicamentos[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        medicamentoTextField.text = medicamentos[row]
    }
    //---------------- DatePicker -------------------
    @objc func mudouData(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        dataTextField.text = formatter.string(from: sender.date)
    }
    //------------------- Botoes ---------------------
    func verDosagemButtom(){
        view.endEditing(true)
        if (medicamentoTextField.text == "") {
            erroMedicamento.text = "Escolha um medicamento"
            erroMedicamento.isHidden = false
            medicamentoTextField.backgroundColor = #colorLiteral(red: 0.7752687335, green: 0.290623188, blue: 0.2677662671, alpha: 0.197403169)
        }
        else if (dataTextField.text == "") {
            dataTextField.backgroundColor = #colorLiteral(red: 0.7752687335, green: 0.290623188, blue: 0.2677662671, alpha: 0.197403169)
            erroData.text = "Insira a data de nascimento da criança"
            erroData.isHidden = false
        }
        else if (pesoTextField.text == "" || Double(pesoTextField.text!)! <= 0) {
            pesoTextField.text = ""
            erroPeso.text = "Insira o peso da criança"
            erroPeso.isHidden = false
            pesoTextField.backgroundColor = #colorLiteral(red: 0.7752687335, green: 0.290623188, blue: 0.2677662671, alpha: 0.197403169)
        }
        else {
            let peso = Double(pesoTextField.text!)!
            let idade = calcularIdade()
            dipirona(idade: idade, peso: peso)
            viewDados.isHidden = true
            viewDosagem.isHidden = false
        }
    }
    func concluidoButtom() {
        medicamentoTextField.text = nil
        dataTextField.text = nil
        pesoTextField.text = nil
        
        medicamentoPicker.selectRow(0, inComponent: 0, animated: true)
        dataPicker.date = Date()
        
        viewDados.isHidden = false
        viewDosagem.isHidden = true
        
        medicamentoTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pesoTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dataTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        erroMedicamento.isHidden = true
        erroData.isHidden = true
        erroPeso.isHidden = true
    }
    //--------------- Outras Funcoes ------------------
    func calcularIdade() -> [Int] {
        let dataNascimento = dataPicker.date
        let hoje = Date()
        let calendario = Calendar.current
        let idade = calendario.dateComponents([.year, .month, .day], from: dataNascimento, to: hoje)
        
        return [idade.year!, idade.month!, idade.day!]
    }
    func dipirona(idade: [Int], peso: Double) {
        if((idade[0] >= 0 || idade[1] >= 3) && peso >= 5) { //idade e peso minimos
            let doseTotal = peso*25*4 //em mg
            let doseMaxima = 4000 //em mg
            let doseX4 = peso*25
            //Solucao oral Gotas: ((dose/500) ml *20) gotas
            //Solucao oral: (dose/50) ml
            //comprimidos: 500 mg (crianca nao engole comprimido)
            //Solucao injetavel: dose/500 ml
            
            medicamento.text = "Dipirona"
            dosagem.text = "De 6 em 6 horas: \n\nSolução Oral 500 mg/mL\n\n\n\nSolução Oral 50 mg/mL\n\n\n\nSolução Injetável 500mg/mL\n"
            
            if(doseTotal <= Double(doseMaxima)) {
                resultado1.text = "\(Int(doseX4/500*20)) gotas"
                resultado2.text = "\(doseX4/50) mL"
                resultado3.text = "\(doseX4/500) mL"            }
            else {
                resultado1.text = "\(Int(1000/500*20)) gotas"
                resultado2.text = "\(1000/50) mL"
                resultado3.text = "\(1000/500) mL"
            }
        }
        else {
            dosagem.text = "Esse medicamento é contra-indicado em crianças menores de 3 meses de idade ou pesando menos de 5 kg."
        }
    }
}
