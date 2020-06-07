import UIKit


class WeatherScreen: UIViewController {
    
    
    var weatherData : WeatherResponse = WeatherResponse(daily: [])
    var dayIndex : Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=50.047056&lon=19.9499011&exclude=hourly&appid=fce0f1f75ae5ce346cbc684f2d996acf&unit=Metric")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!)
            
            self.weatherData = try!JSONDecoder().decode(WeatherResponse.self, from: data!)

            DispatchQueue.main.async {
               self.changeDay(index: 0)
            }
            
         
            
        }

        task.resume()

    }
    

    @IBOutlet weak var Temperature: UILabel!
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var CurrentDate: UILabel!
    @IBOutlet weak var Pressure: UILabel!
    @IBOutlet weak var PrevButton: UIButton!
    @IBOutlet weak var NextButton: UIButton!
    
    @IBAction func NextDayButtonTapped(_ sender: UIButton) {
        changeDay(index: self.dayIndex + 1)
    }
    

    @IBAction func PrevDayButtonTapped(_ sender: UIButton) {
                changeDay(index: self.dayIndex - 1)
    }
    
    
    func changeDay(index: Int) {

    
        let maxDay = self.weatherData.daily.count-1
        var newIndex = min(index, maxDay)
        newIndex = max(index, 0)
        
        self.dayIndex = newIndex
        
        PrevButton.isEnabled = newIndex > 0
        if newIndex > 0 {
            PrevButton.alpha = 1;
        } else {
            PrevButton.alpha = 0.5;
        }
        
        NextButton.isEnabled = newIndex < maxDay
        if newIndex < maxDay {
            NextButton.alpha = 1;
        } else {
            NextButton.alpha = 0.5;
        }

        
        
        let currentDay = self.weatherData.daily[newIndex]
        
        let iconName = currentDay.weather[0].icon
        
        let imageUrl = URL(string: "https://openweathermap.org/img/wn/" + iconName + "@2x.png")!
        self.downloadImage(from: imageUrl)
        
        
        let date = Date(timeIntervalSince1970: Double(currentDay.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        DispatchQueue.main.async {
           self.CurrentDate.text = dateFormatter.string(from: date)
           self.Temperature.text = String(currentDay.temp.day) + " °C"
           self.Pressure.text = String(currentDay.pressure) + " hpa"
        }

    }
    

    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                self?.WeatherImage.image = UIImage(data: data)
            }
        }
    }
    
}
