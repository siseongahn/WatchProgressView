//
//  WatchProgressView.swift
//  WatchProgressBar
//
//  Created by Simon on 11/20/23.
//

import UIKit

@IBDesignable
class WatchProgressView: UIView
{
    // The color of the full track start.
    @IBInspectable var trackStartTint: UIColor {

        get { return iStartTrackColor }

        set
        {
            if newValue != iStartTrackColor
            {
                iStartTrackColor = newValue
                setNeedsDisplay()
            }
        }
    }
    private var iStartTrackColor: UIColor = UIColor.darkGray
    
    // The color of the full track end.
    @IBInspectable var trackEndTint: UIColor {

        get { return iEndTrackColor }

        set
        {
            if newValue != iEndTrackColor
            {
                iEndTrackColor = newValue
                setNeedsDisplay()
            }
        }
    }
    private var iEndTrackColor: UIColor = UIColor.lightGray


    // The color of the part of the track representing progress start.
    @IBInspectable var progressStartTint: UIColor {

        get { return iStartProgressColor }

        set
        {
            if newValue != iStartProgressColor
            {
                iStartProgressColor = newValue
                setNeedsDisplay()
            }
        }
    }
    private var iStartProgressColor: UIColor = .yellow
    
    // The color of the part of the track representing progress end.
    @IBInspectable var progressEndTint: UIColor {

        get { return iEndProgressColor }

        set
        {
            if newValue != iEndProgressColor
            {
                iEndProgressColor = newValue
                setNeedsDisplay()
            }
        }
    }
    private var iEndProgressColor: UIColor = .red


    @IBInspectable var trackStartAngle: CGFloat {

        get { return iStartAngle }

        set
        {
            if newValue != iStartAngle
            {
                iStartAngle = newValue
                setNeedsDisplay()
            }
        }
    }
    private var   iStartAngle: CGFloat = 140.0 // degree
    
    @IBInspectable var trackEndAngle: CGFloat {

        get { return iEndAngle }

        set
        {
            if newValue != iEndAngle
            {
                iEndAngle = newValue
                setNeedsDisplay()
            }
        }
    }
    private var   iEndAngle: CGFloat = 400.0 // degree
    

    // The thickness of the full track, in points. It shouldn't be less than minTrackThickness,
    // and is clipped to that value if set otherwise. Always set this value before setting the
    // values of either progressThickness or progressThicknessFraction.
    @IBInspectable var trackThickness: CGFloat {

        get { return iTrackThickness }

        set
        {
            if newValue != iTrackThickness
            {
                iTrackThickness = max(minTrackThickness, newValue)
                updateProgressThickness(value: iProgressThickness)
                setNeedsDisplay()
            }
        }
    }
    private var   iTrackThickness: CGFloat = 30.0 // points
    private let minTrackThickness: CGFloat =  6.0 // points


    // The thickness of the part of the track representing progress, in points. Alternatively,
    // use progressThicknessFraction (see below) to set the progress thickness. progressThickness
    // should be in the range [minProgressThickness, trackThickness]. Note that the range depends
    // on the current value of trackThickness so always set that value first before setting the value
    // of progressThickness.
    @IBInspectable var progressThickness: CGFloat {

        get { return iProgressThickness }

        set
        {
            if newValue != iProgressThickness
            {
                updateProgressThickness(value: newValue)
                setNeedsDisplay()
            }
        }
    }
    private var   iProgressThickness: CGFloat = 10.0 // points
    private let minProgressThickness: CGFloat =  2.0 // points


    // The thickness of the part of the track representing progress, as a fraction of the full track
    // thickness. Alternatively, use progressThickness (see above) to set the progress thickness.
    // progressThicknessFraction should be a floating point number in the range
    // [minProgressThickness/trackThickness, 1]. Values outside that range are clipped to that range.
    // Note that the range depends on the current value of trackThickness so always set that value
    // first before setting the value of progressThicknessFraction.
    /*@IBInspectable*/ var progressThicknessFraction: CGFloat {

        get { return iProgressThicknessFraction }

        set
        {
            if newValue != iProgressThicknessFraction
            {
                iProgressThicknessFraction = max(minProgressThickness / iTrackThickness, newValue)
                iProgressThicknessFraction = min(iProgressThicknessFraction, 1)
                self.progressThickness = iProgressThicknessFraction * iTrackThickness
                setNeedsDisplay()
            }
        }
    }
    private var iProgressThicknessFraction: CGFloat = 0.5

    
    // Whether to display the percent label. Setting this property is equivalent to accessing the
    // percent label directly and hiding or unhiding it so it's just a convenience.
    @IBInspectable var showPercent: Bool {

        get { return iShowPercent }

        set
        {
            // if showing then we want to have a label; do something innocuous to force the label to be created.
            if newValue { self.percentLabel?.alpha = 1.0 }

            if newValue != iShowPercent
            {
                iShowPercent = newValue
                iPercentLabel?.isHidden = !iShowPercent
                if iShowPercent { updateLabel() }
                setNeedsDisplay()
            }
        }
    }
    private var iShowPercent = true


    // The color of the percent text when it's showing. Setting this property is equivalent to accessing the
    // percent label directly and setting its text color property so it's just a convenience.
    @IBInspectable var percentTint: UIColor {

        get { return iPercentTint }

        set
        {
            if newValue != iPercentTint
            {
                iPercentTint = newValue
                iPercentLabel?.textColor = iPercentTint
                setNeedsDisplay()
            }
        }
    }
    private var iPercentTint = UIColor.black


    // The font size of the percent text when it's showing. Setting this property is equivalent to
    // accessing the percent label directly and setting its text font size so it's just a convenience.
    @IBInspectable var percentSize: CGFloat {

        get { return iPercentSize }

        set
        {
            if newValue != iPercentSize
            {
                iPercentSize = newValue
                updateLabelFontSize()
                setNeedsDisplay()
            }
        }
    }
    private var iPercentSize: CGFloat = 48


    // Whether to display the percent text using the bold or regular system font. Setting this property is
    // equivalent to accessing the percent label directly and setting its font property so it's just a convenience.
    @IBInspectable var percentBold: Bool {

        get { return iPercentBold }

        set
        {
            if newValue != iPercentBold
            {
                iPercentBold = newValue
                updateLabelFontSize()
                setNeedsDisplay()
            }
        }
    }
    private var iPercentBold = true


    // The value representing the progress made. It should be in the range [0, 1]. Values outside
    // that range will be clipped to that range.
    @IBInspectable var value: Float {

        get { return Float(iValue) }

        set
        {
            let val: CGFloat
            #if TARGET_INTERFACE_BUILDER
                val = 0.01 * CGFloat(newValue) // interpret the integers in the inspector stepper as percentages
            #else
                val = CGFloat(newValue)
            #endif

            if val != iValue
            {
                iValue = max(0, val)
                iValue = min(iValue, 1)
                updateLabel()
                setNeedsDisplay()
            }
        }
    }
    
    private var iValue: CGFloat = 0.75
    private var gradationStep = 100
    
    
    // An optional UILabel to appear at the center of the circular progress view. This property can
    // be set with any UILabel instance or one can be automatically provided, then accessed and
    // customized as desired. Note that, either way, certain layout constraints are created to
    // keep the label centered. Those constraints should not be messed with.
    @IBOutlet var percentLabel: UILabel? {

        get
        {
            if iPercentLabel == nil { self.percentLabel = UILabel() }
            return iPercentLabel
        }

        set(newLabel)
        {
            if newLabel != iPercentLabel
            {
                iPercentLabel?.removeFromSuperview()
                iPercentLabel = newLabel

                if let label = iPercentLabel
                {
                    addSubview(label)

                    updateLabelFontSize()
                    label.textColor = iPercentTint

                    label.textAlignment = .center
                    label.adjustsFontSizeToFitWidth = true
                    label.baselineAdjustment = .alignCenters
                    label.minimumScaleFactor = 0.5
                    
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.removeConstraints(label.constraints)

                    var constraint: NSLayoutConstraint

                    constraint = NSLayoutConstraint(item: label, attribute: .centerX,
                                                    relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
                    addConstraint(constraint)

                    constraint = NSLayoutConstraint(item: label, attribute: .centerY,
                                                    relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
                    addConstraint(constraint)

                    let w = CGRectGetWidth(bounds)
                    let h = CGRectGetHeight(bounds)
                    var s = (min(w, h) - iTrackThickness) / 2
                    s *= 0.9 // Use up to 90% of the space between opposite sides of the inner circle.

                    constraint = NSLayoutConstraint(item: label, attribute: .width,
                                                    relatedBy: .lessThanOrEqual, toItem: self, attribute: .width, multiplier: 0.0, constant: s)
                    addConstraint(constraint)

                    constraint = NSLayoutConstraint(item: label, attribute: .height,
                                                    relatedBy: .lessThanOrEqual, toItem: self, attribute: .height, multiplier: 0.0, constant: s)
                    addConstraint(constraint)

                    updateLabel()
                    setNeedsDisplay()
                }
            }
        }
    }
    private var iPercentLabel: UILabel?


    override func draw(_ rect: CGRect)
    {
        let w = CGRectGetWidth(bounds)
        let h = CGRectGetHeight(bounds)
        let r = (min(w, h) - iTrackThickness) / 2
        let cp = CGPoint(x: w/2, y: h/2)

        // Draw the full track.
        fillGradientTrack(center: cp, radius: r, sangle: iStartAngle, eangle: iEndAngle)

        // Draw the progress track.
        if iValue == 0 {
            return
        }

        let diff = iEndAngle - iStartAngle
        let valAngle = CGFloat((Double(iValue) * diff) + iStartAngle)
        fillGradientProgress(center: cp, radius: r, sangle: iStartAngle, eangle: valAngle)
    }

    private func fillGradientTrack(center: CGPoint, radius: CGFloat, sangle: CGFloat, eangle: CGFloat)
    {
        let gradations = gradationStep
        
        var startColorR:CGFloat = 0
        var startColorG:CGFloat = 0
        var startColorB:CGFloat = 0
        var startColorA:CGFloat = 0

        var endColorR:CGFloat = 0
        var endColorG:CGFloat = 0
        var endColorB:CGFloat = 0
        var endColorA:CGFloat = 0

        iStartTrackColor.getRed(&startColorR, green: &startColorG, blue: &startColorB, alpha: &startColorA)
        iEndTrackColor.getRed(&endColorR, green: &endColorG, blue: &endColorB, alpha: &endColorA)

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        var angle = sangle

        for i in 1 ... gradations {
            let extraAngle = (eangle - sangle) / CGFloat(gradations)
            let currentStartAngle = angle
            let currentEndAngle = currentStartAngle + extraAngle

            let currentR = ((endColorR - startColorR) / CGFloat(gradations - 1)) * CGFloat(i - 1) + startColorR
            let currentG = ((endColorG - startColorG) / CGFloat(gradations - 1)) * CGFloat(i - 1) + startColorG
            let currentB = ((endColorB - startColorB) / CGFloat(gradations - 1)) * CGFloat(i - 1) + startColorB
            let currentA = ((endColorA - startColorA) / CGFloat(gradations - 1)) * CGFloat(i - 1) + startColorA

            let currentColor = UIColor.init(red: currentR, green: currentG, blue: currentB, alpha: currentA)

            let path = UIBezierPath()
            path.lineWidth = iTrackThickness
            path.lineCapStyle = .round
            path.addArc(withCenter: center, radius: radius, startAngle: currentStartAngle * CGFloat(Double.pi / 180.0), endAngle: currentEndAngle * CGFloat(Double.pi / 180.0), clockwise: true)
            currentColor.setStroke()
            path.stroke()
            angle = currentEndAngle
        }
    }
    
    private func fillGradientProgress(center: CGPoint, radius: CGFloat, sangle: CGFloat, eangle: CGFloat)
    {
        let gradations = ((iEndAngle - iStartAngle) * iValue) + CGFloat(gradationStep)
        let maskGradatins = Int(gradations * iValue)
        if maskGradatins < 1 {
            return
        }
        
        var startColorR:CGFloat = 0
        var startColorG:CGFloat = 0
        var startColorB:CGFloat = 0
        var startColorA:CGFloat = 0

        var endColorR:CGFloat = 0
        var endColorG:CGFloat = 0
        var endColorB:CGFloat = 0
        var endColorA:CGFloat = 0

        iStartProgressColor.getRed(&startColorR, green: &startColorG, blue: &startColorB, alpha: &startColorA)
        iEndProgressColor.getRed(&endColorR, green: &endColorG, blue: &endColorB, alpha: &endColorA)

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        var angle = sangle

        for i in 1 ... maskGradatins {
            let extraAngle = (eangle - sangle) / (gradations * iValue)
            let currentStartAngle = angle
            let currentEndAngle = currentStartAngle + extraAngle

            let currentR = ((endColorR - startColorR) / (gradations - 1.0)) * CGFloat(i - 1) + startColorR
            let currentG = ((endColorG - startColorG) / (gradations - 1.0)) * CGFloat(i - 1) + startColorG
            let currentB = ((endColorB - startColorB) / (gradations - 1.0)) * CGFloat(i - 1) + startColorB
            let currentA = ((endColorA - startColorA) / (gradations - 1.0)) * CGFloat(i - 1) + startColorA

            let currentColor = UIColor.init(red: currentR, green: currentG, blue: currentB, alpha: currentA)

            let path = UIBezierPath()
            path.lineWidth = iProgressThickness
            path.lineCapStyle = .round
            path.addArc(withCenter: center, radius: radius, startAngle: currentStartAngle * CGFloat(Double.pi / 180.0), endAngle: currentEndAngle * CGFloat(Double.pi / 180.0), clockwise: true)
            currentColor.setStroke()
            path.stroke()
            angle = currentEndAngle
        }
    }

    private func updateProgressThickness(value: CGFloat)
    {
        iProgressThickness = max(minProgressThickness, value)
        iProgressThickness = min(iProgressThickness, iTrackThickness)
        self.progressThicknessFraction = iProgressThickness / iTrackThickness
    }


    private func updateLabelFontSize()
    {
        if iPercentBold
        {
            iPercentLabel?.font = UIFont.boldSystemFont(ofSize: iPercentSize)
        }
        else
        {
            iPercentLabel?.font = UIFont.systemFont(ofSize: iPercentSize)
        }
    }


    private func updateLabel()
    {
        if let label = iPercentLabel, !label.isHidden
        {
            let val = iValue
            label.text = "\(Int(val * 100.0) % 101) %"
            label.sizeToFit()
            setNeedsLayout()
        }
    }


    #if TARGET_INTERFACE_BUILDER

    override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        percentLabel?.isHidden = !showPercent
    }

    #endif
}
