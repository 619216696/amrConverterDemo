import { nativeConvertAmrToPcm, nativeConvertPcmToAmr } from '@charles/amrnbconverter'
import fs from '@ohos.file.fs'

@Entry
@Component
struct Index {
  private readonly amrSourceFilePath = `${getContext(this).cacheDir}/16b-1c-8000hz.amr`
  private readonly pcmSourceFilePath = `${getContext(this).cacheDir}/16b-1c-8000hz.pcm`

  private async ensureAmrSourceFileExist() {
    if (fs.accessSync(this.amrSourceFilePath)) return
    // copy from rawFile
    const data = await getContext(this).resourceManager.getRawFileContent('16b-1c-8000hz.amr')
    const file = fs.openSync(this.amrSourceFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    fs.writeSync(file.fd, data.buffer)
    fs.closeSync(file)
  }

  private async ensurePcmSourceFileExist() {
    if (fs.accessSync(this.pcmSourceFilePath)) return
    // copy from rawFile
    const data = await getContext(this).resourceManager.getRawFileContent('16b-1c-8000hz.pcm')
    const file = fs.openSync(this.pcmSourceFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    fs.writeSync(file.fd, data.buffer)
    fs.closeSync(file)
  }

  private readonly amr2pcm = async () => {
    await this.ensureAmrSourceFileExist()
    const pcmFilePath = `${getContext(this).cacheDir}/result.pcm`
    const result = await nativeConvertAmrToPcm(this.amrSourceFilePath, pcmFilePath)
    console.log('amr2pcm result: ', result)
    this.getUIContext().getPromptAction().showToast({
      message: result ? 'success' : 'failed'
    })
  }

  private readonly pcm2amr = async () => {
    await this.ensurePcmSourceFileExist()
    const amrFilePath = `${getContext(this).cacheDir}/result.amr`
    const result = await nativeConvertPcmToAmr(this.pcmSourceFilePath, amrFilePath)
    console.log('pcm2amr result: ', result)
    this.getUIContext().getPromptAction().showToast({
      message: result ? 'success' : 'failed'
    })
  }

  build() {
    Column({ space: 20 }) {
      Button('amr -> pcm')
        .onClick(this.amr2pcm)

      Button('pcm -> amr')
        .onClick(this.pcm2amr)
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}