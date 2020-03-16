//
//  ViewController.swift
//  PedCalc
//
//  Created by Íris Soares on 02/03/20.
//  Copyright © 2020 Íris Soares. All rights reserved.
//

import UIKit
import Foundation

//------------ variaveis globais ----------------

let medicamentos = ["Ácido acetilsalicílico", "Ácido mefenânico", "Benzidamina", "Cetoprofeno", "Diclofenaco Potássico", "Diclofenaco Sódico", "Dipirona", "Ibuprofeno", "Indometacina", "Morfina", "Naproxeno", "Nimesulida", "Paracetamol", "Petidina", "Piroxicam", "Tramadol"]
var medicamentoSelecionado = ""
var medicamentoPicker = UIPickerView()
var dataPicker = UIDatePicker()
var idadeAnos = 0
var idadeMeses = 0
var idadeDias = 0

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBAction func verDosagem() {verDosagemButtom()}
    @IBAction func concluido() {concluidoButtom()}
    @IBOutlet weak var medicamentoTextField: UITextField!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet var pesoTextField: UITextField!
    @IBOutlet var medicamento: UILabel!
    @IBOutlet var dosagemInfo: UILabel!
    @IBOutlet var viewDados: UIView!
    @IBOutlet var viewDosagem: UIView!
    @IBOutlet var mensagemErro: UILabel!
    
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
        medicamentoSelecionado = medicamentos[row]
    }
    //---------------- DatePicker -------------------
    @objc func mudouData(sender: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        dataTextField.text = formatter.string(from: sender.date)
        calcularIdade()
    }
    //------------------- Botoes ---------------------
    func verDosagemButtom(){
        view.endEditing(true)
        if (medicamentoTextField.text == "") {
            medicamentoTextField.placeholder = "Escolha um medicamento"
            medicamentoTextField.backgroundColor = #colorLiteral(red: 0.7752687335, green: 0.290623188, blue: 0.2677662671, alpha: 0.197403169)
        }
        else if (medicamentoTextField.text != "Dipirona") {
            medicamentoTextField.text = ""
            medicamentoTextField.placeholder = "Só temos Dipirona disponível no momento"
            medicamentoTextField.backgroundColor = #colorLiteral(red: 0.7752687335, green: 0.290623188, blue: 0.2677662671, alpha: 0.197403169)
        }
        else if (dataTextField.text == "") {
            dataTextField.placeholder = "Escolha um medicamento"
            medicamentoTextField.backgroundColor = #colorLiteral(red: 0.7752687335, green: 0.290623188, blue: 0.2677662671, alpha: 0.197403169)
        }
        else if (pesoTextField.text == "" || Double(pesoTextField.text!)! <= 0) {
            pesoTextField.text = ""
            pesoTextField.placeholder = "Insira um peso válido"
            pesoTextField.backgroundColor = #colorLiteral(red: 0.7752687335, green: 0.290623188, blue: 0.2677662671, alpha: 0.197403169)
        }
        else {
            let peso = Double(pesoTextField.text!)!
            if(descobrirDosagem(medicamentoS: medicamentoSelecionado, idadeMeses: idadeMeses, idadeAnos: idadeAnos, peso: peso)){
                viewDados.isHidden = true
                viewDosagem.isHidden = false
            }
            else {
                pesoTextField.text = ""
                pesoTextField.placeholder = "O peso não bate com a idade da criança"
                pesoTextField.backgroundColor = #colorLiteral(red: 0.7752687335, green: 0.290623188, blue: 0.2677662671, alpha: 0.197403169)
            }
        }
    }
    func concluidoButtom() {
        self.medicamentoTextField.text = nil
        medicamentoPicker.selectRow(0, inComponent: 0, animated: true)
        self.dataTextField.text = nil
        dataPicker.date = Date()
        self.pesoTextField.text = nil
        viewDados.isHidden = false
        viewDosagem.isHidden = true
        medicamentoTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        medicamentoTextField.placeholder = "Ex.: Dipirona"
        pesoTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pesoTextField.placeholder = "em Kg"
    }
    //--------------- Outras Funcoes ------------------
    func calcularIdade () {
        let dataNascimento = dataPicker.date
        let hoje = Date()
        let calendario = Calendar.current
        let idade = calendario.dateComponents([.year, .month, .day], from: dataNascimento, to: hoje)
        
        idadeAnos = idade.year!
        idadeMeses = idade.month!
        idadeDias = idade.day!
    }
    /*TODO
     - salvar os dados de alguns medicamentos;
     - conferir os dados com os medicamentos pra gerar saidas de acordo com a medicacao/idade/peso
     */
    func descobrirDosagem(medicamentoS: String, idadeMeses: Int, idadeAnos: Int, peso: Double) -> Bool{
        if(medicamentoS == "Dipirona") {
            medicamento.text = "Dipirona"
            if (peso >= 5 && peso <= 8 && idadeAnos == 0 && idadeMeses >= 3 && idadeMeses <= 11) {
                dosagemInfo.text = "Uso Oral (50 mg/mL):\n1,25-2,5 mL VO em dose única\nDose máxima diária: 10mL\n(4 tomadas x 2,5 mL)\n\nUso Oral (500 mg/mL):\n2-5 gotas VO em dose única\nDose máxima diária: 20 gotas\n(4 tomadas x 5 gotas)"
                return true
            }
            else if (peso >= 9 && peso <= 15 && idadeAnos >= 1 && idadeAnos <= 3) {
                dosagemInfo.text = "Uso Oral (50 mg/mL):\n2,5-5 mL VO em dose única\nDose máxima diária: 20 mL\n(4 tomadas x 5 mL)\n\nUso Oral (500 mg/mL):\n3-10 gotas VO em dose única\nDose máxima diária: 40 gotas\n(4 tomadas x 10 gotas)"
                return true
            }
            else if (peso >= 16 && peso <= 23 && idadeAnos >= 4 && idadeAnos <= 6) {
                dosagemInfo.text = "Uso Oral (50 mg/mL):\n3,75-7,5 mL VO em dose única\nDose máxima diária: 30 mL\n(4 tomadas x 7,5 mL)\n\nUso Oral (500 mg/mL):\n5-15 gotas VO em dose única\nDose máxima diária: 60 gotas\n(4 tomadas x 15 gotas)"
                return true
            }
            else if (peso >= 24 && peso <= 30 && idadeAnos >= 7 && idadeAnos <= 9) {
                dosagemInfo.text = "Uso Oral (50 mg/mL):\n5-10 mL VO em dose única\nDose máxima diária: 20 mL\n(4 tomadas x 5 mL)\n\nUso Oral (500 mg/mL):\n8-20 gotas VO em dose única\nDose máxima diária: 80 gotas\n(4 tomadas x 20 gotas)"
                return true
            }
            else if (peso >= 31 && peso <= 45 && idadeAnos >= 10 && idadeAnos <= 12) {
                dosagemInfo.text = "Uso Oral (50 mg/mL):\n7,5-15 mL VO em dose única\nDose máxima diária: 60 mL\n(4 tomadas x 15 mL)\n\nUso Oral (500 mg/mL):\n10-30 gotas VO em dose única\nDose máxima diária: 120 gotas\n(4 tomadas x 30 gotas)"
                return true
            }
            else if (peso >= 46 && peso <= 53 && idadeAnos >= 13 && idadeAnos <= 14) {
                dosagemInfo.text = "Uso Oral (50 mg/mL):\n8,75-17,5 mL VO em dose única\nDose máxima diária: 70 mL\n(4 tomadas x 17,5 mL)\n\nUso Oral (500 mg/mL):\n15-35 gotas VO em dose única\nDose máxima diária: 140 gotas\n(4 tomadas x 35 gotas)"
                return true
            }
        }
        return false
    }

}
