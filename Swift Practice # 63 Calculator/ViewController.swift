//
//  ViewController.swift
//  Swift Practice # 63 Calculator
//
//  Created by Dogpa's MBAir M1 on 2021/8/21.
//

import UIKit


class ViewController: UIViewController {
    
    //上面狀態列的顯示樣式為lightContent樣式 在黑暗模式內可以看到
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    //計算結果的label
    @IBOutlet weak var calculateResultLabel: UILabel!
    
    //定義計算機中需要使用的變數
    var numberOnLabel : Double = 0      //正顯示在label上的數字
    var previousNumber : Double = 0     //進行四則運算符號前的數字
    var performingMath = false          //判斷是否正在運行四則運算
    var operation = "none"              //判斷目前四則運算的狀態(看是正在 + - * / 哪一個)
    var startNew = true                 //確認是否有重新開始


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //加減乘除會共同用到的改成func方便使用
    func changeASMDState (labelText : String, operationText : String){
        calculateResultLabel.text = labelText   //計算機上的label顯示的數值
        operation = operationText               //四則運算目前的狀態
        performingMath = true                   //正在進行四則運算的狀態是 true 布林值
        previousNumber = numberOnLabel          //若進行四則運算 將在按下 +-*/前的數字存到previousNumber
    }
    
    //透過func去判斷label顯示的需要是整數或是小數點
    func checkIntOrFloat (from number:Double){
        var  LabelText : String             //定義labelText為字串格式
        if floor(number) == number {        //若是使用floor無條件捨去的函數去執行結果等於傳進來的數字(簡單說就是沒有小數點)
            LabelText = "\(Int(number))"    //將剛剛的浮點數的正整數轉型為Int後存入給LabelText
        }else{                              //若兩者不等於(就是傳入數字有小數點位元不是整數)
            LabelText = "\(number)"         //直接傳入給LabelText不用透過Int轉型
        }
        if LabelText.count >= 9 {                   //若是有小數點超過9位數（除不盡）
            LabelText = String(LabelText.prefix(9)) //透過String的.prefix去抓前9個數字顯示（前9個數含小數點）
        }
        calculateResultLabel.text = LabelText       //計算機上顯示的數字為LabelText存入的值
    }
    
    //若是需要多重運算，則透過AnswerForNow去判斷前面的運算結果先存入在numberOnLabel的值內
    //若是要(除/0)則跳出警告
    func AnswerForNow () {
        if performingMath == true {                             //若是正在進行四則運算
            if operation == "add" {                             //若是正在 +
                numberOnLabel = previousNumber + numberOnLabel  // numberOnLabel的值等於目前的值「加上」四則運算前的值
            }else if operation == "substract" {                 //若是正在 -
                numberOnLabel = previousNumber - numberOnLabel  // numberOnLabel的值等於目前的值「減去」四則運算前的值
            }else if operation == "multiply" {                  //若是正在 *
                numberOnLabel = previousNumber * numberOnLabel  // numberOnLabel的值等於目前的值「乘上」四則運算前的值
            }else if operation == "divide" {                    //若是正在 / (除)
                if numberOnLabel == 0 {                         //判斷目前要除的數字是否為0 若為0 跳出警告視窗
                    let alert = UIAlertController(title: "有點錯誤", message: "整數除 0 等於 0", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true, completion: nil)
                }else{                                                  //若要除的值不是0
                    numberOnLabel = previousNumber / numberOnLabel      // numberOnLabel的值等於四則運算前的值除去」目前輸入的值
                }
            }else if operation == "none"{                       //若沒有正在四則運算
                calculateResultLabel.text = "0"                 //螢幕上的Label則顯示為 0
            }
        }
    }

    
    //0-9 10個按鈕的動作
    @IBAction func pressToCalculate(_ sender: UIButton) {
        
        let inputNumber = sender.tag - 1                        //透過設定好的Button的Tag去判斷所選的按鈕為多少
        
        
        //將所選的按鈕數字顯示在calculateResultLabel上
        if calculateResultLabel.text != nil{                    //判斷若螢幕上的輸入值沒有值
            if startNew == true {                               //再判斷是否有重新計算若是重新計算
                calculateResultLabel.text = "\(inputNumber)"    //螢幕顯示數字的值等於按下去的Button
                startNew = false                                //將重新計算改成false表示要開始進行運算
            }else{                                              //若startNew判斷為false表示正在進行運算
                //若是目前的螢幕表示為 0（表示剛開始）或是已經開始正在進行四則運算的其中一個
                if calculateResultLabel.text == "0" || calculateResultLabel.text == "+" || calculateResultLabel.text == "-" || calculateResultLabel.text == "x" || calculateResultLabel.text == "/"{
                    //表示現在為新的狀態或是接下來是四則運算後準備輸入的新的數字，則此按下的Button即會成為label上的顯示的值
                    calculateResultLabel.text = "\(inputNumber)"
                }else{
                    //若輸入數字不為0或是螢幕上顯示的不是正在 +  - *  / 其中一個
                    //則表示輸入者正在按目前的數字但是我們不知道實際數字會按出什麼
                    //所以讓Label的值去加上目前正在加入的值
                    //表示還正在按四則運算後的值或是四則運算前的值
                    calculateResultLabel.text = calculateResultLabel.text! + "\(inputNumber)"
                }
                
            }
            //將Label上顯示的值(已經完成的)透過轉型轉為Double後放在 numberOnLabel 內，若無法判斷則回傳 0
            numberOnLabel = Double(calculateResultLabel.text!) ?? 0
        }

    }
    
    //清除Ｃ的Button初始值全部歸零
    @IBAction func labelReset(_ sender: UIButton) {
        calculateResultLabel.text = "0" //顯示Label歸0
        numberOnLabel = 0               //存Label的數字的值歸0
        previousNumber = 0              //四則運算前的值也歸0
        performingMath = false          //是否正在進行四則運算判斷為否
        operation = "none"              //四則運算狀態字串返回none
        startNew = true                 //是否進行新的運算判斷為true
    }
    
    // +法
    @IBAction func add(_ sender: UIButton) {
        AnswerForNow()                                          //先執行AnswerForNow() 功能 判斷是否有前面正在進行的四則運算
        changeASMDState(labelText: "+", operationText: "add")   //執行changeASMDState()功能，傳入兩個字串的狀態去執行
    }
    
    // -法
    @IBAction func substract(_ sender: UIButton) {
        AnswerForNow()                                              //先執行AnswerForNow() 功能 判斷是否有前面正在進行的四則運算
        changeASMDState(labelText: "-", operationText: "substract") //執行changeASMDState()功能，傳入兩個字串的狀態去執行
    }
    
    // x法
    @IBAction func multiply(_ sender: UIButton) {
        AnswerForNow()                                              //先執行AnswerForNow() 功能 判斷是否有前面正在進行的四則運算
        changeASMDState(labelText: "x", operationText: "multiply")  //執行changeASMDState()功能，傳入兩個字串的狀態去執行
    }
    
    // (/)
    @IBAction func divide(_ sender: UIButton) {
        AnswerForNow()                                              //先執行AnswerForNow() 功能 判斷是否有前面正在進行的四則運算
        changeASMDState(labelText: "/", operationText: "divide")    //執行changeASMDState()功能，傳入兩個字串的狀態去執行
    }
    
    // (=)
    @IBAction func answer(_ sender: UIButton) {
        if performingMath == true {
            if operation == "add" {
                numberOnLabel = previousNumber + numberOnLabel
                checkIntOrFloat(from: numberOnLabel)
            }else if operation == "substract" {
                numberOnLabel = previousNumber - numberOnLabel
                checkIntOrFloat(from: numberOnLabel)
            }else if operation == "multiply" {
                numberOnLabel = previousNumber * numberOnLabel
                checkIntOrFloat(from: numberOnLabel)
            }else if operation == "divide" {
                if numberOnLabel == 0 {
                    let alert = UIAlertController(title: "有點錯誤", message: "整數除 0 等於 0", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true, completion: nil)
                }else{
                    numberOnLabel = previousNumber / numberOnLabel
                    checkIntOrFloat(from: numberOnLabel)
                }
            }else if operation == "none"{
                calculateResultLabel.text = "0"
            }
            
            performingMath = false  //按下等於表示運算已經結束 所以正在運算的狀態改成false
            startNew = true         //按下等於表示一則運算式已經完成運算 所以接下來會進行新的運算則startNew則為true
                                    //若是運算完(按下等於後)想要再次按下新的運算
                                    //可以視為運算結果(按下等於後的值)為按下四則運算前的值
        
    }
    
}
}
