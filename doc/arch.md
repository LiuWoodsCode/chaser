VcNexradRadar
    private var nexradState = NexradState()
        var wxMetalRenders = [NexradRender?]()
            var wxMetalTextObject: NexradRenderTextObject
            var renderFn: ((Int) -> Void)?
            let fileStorage = FileStorage()
                var memoryBuffer = MemoryBuffer()
                var memoryBufferL2 = MemoryBuffer()
                var animationMemoryBuffer = [MemoryBuffer]()
                var animationMemoryBufferL2 = [MemoryBuffer]()
                var stiList = [Double]()
                var hiData = [Double]()
                var tvsData = [Double]()
                etc...
            let state = NexradRenderState()
                var xPos: Float = 0.0
                var yPos: Float = 0.0
                let zPos: Float = -7.0
                var zoom: Float = 1.0
                var projectionNumbers = ProjectionNumbers()
                var paneNumber = 0
                var numberOfPanes = 1
                var displayHold = false
                var gpsLocation = LatLon()
                var gpsLatLonTransformed: (Float, Float) = (0.0, 0.0)
            var data = NexradRenderData()
                var radarLayers = [MetalBuffers]()
                var radarBuffers = MetalRadarBuffers(RadarPreferences.nexradRadarBackgroundColor)
                var geographicBuffers = [MetalBuffers]()
                var stateLineBuffers = MetalBuffers(GeographyType.stateLines, 0.0)
                var mxLineBuffers = MetalBuffers(GeographyType.mxLines, 0.0)
                etc...
            let construct: NexradRenderConstruct!
                let device: MTLDevice
                let fileStorage: FileStorage
                let state: NexradRenderState
                var scaleLengthLocationDot: ((Double) -> Double)?
        var wxMetalTextObject = NexradRenderTextObject()
        var device: MTLDevice! = MTLCreateSystemDefaultDevice()
        var metalLayer = [CAMetalLayer?]()
        var pipelineState: MTLRenderPipelineState!
        var commandQueue: MTLCommandQueue!
        var paneRange: Range<Int> = 0..<1
        var numberOfPanes = 1
        let ortInt: Float = 250.0
        private var screenWidth = 0.0
        private var screenHeight = 0.0
        private var screenScale = 0.0
        var projectionMatrix: float4x4!
    private var nexradUI = NexradUI()
    private var nexradAnimation: NexradAnimation!
    private var nexradSubmenu: NexradSubmenu!
    private var nexradColorLegend = NexradColorLegend()
    private var nexradLayerDownload: NexradLayerDownload!
    private var nexradLongPress: NexradLongPressMenu!

VcTabLocation
    private var nexradTab = NexradTab()
        var uiv: VcTabLocation!
        private var longPressCount = 0
        let nexradStateHS = NexradStateHS()
            var wxMetal = [NexradRender?]()
            var wxMetalTextObject = NexradRenderTextObject()
            let device = MTLCreateSystemDefaultDevice()
            var metalLayer = [CAMetalLayer?]()
            var pipelineState: MTLRenderPipelineState!
            var commandQueue: MTLCommandQueue!
            let numberOfPanes = 1
            let ortInt: Float = 350.0
            var projectionMatrix: float4x4!
        private var nexradTabLongPressMenu: NexradTabLongPressMenu!
