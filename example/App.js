/**
 * Test
 */
import React, {Component, useEffect, useState} from 'react';
import {
  View,
  Text,
  Button,
  Modal,
  FlatList,
  ListItem,
  NativeModules,
  TouchableWithoutFeedback,
  Pressable,
  ActivityIndicator,
} from 'react-native';
import ChoiceModal from './ChoiceModal';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isOpenModal: false,
      listPrinter: [],
      isLoading: false,
      isConnect: false,
    };
  }
  _startScan = async () => {
    this.setState({isLoading: true});
    await NativeModules.RNRongta.getDevicesList((error, listDevice) => {
      this.setState({isLoading: false});
      if (error) {
        alert(error);
      } else {
        console.log('_startScan', listDevice);
        if (listDevice.length > 0) {
          this.setState({listPrinter: listDevice, isOpenModal: true});
        } else {
          alert('No device is searched');
        }
      }
    });
  };
  _startPrint = () => {
    NativeModules.RNRongta.print('test print');
  };
  setModalVisible = async (value, item, index) => {
    console.log('setModalVisible', item, index);
    // close modal
    this.setState({
      isOpenModal: value,
    });
    // connect to device in native
    await NativeModules.RNRongta.connectToDevice(item.id, isSuccess => {
      if (isSuccess == '1') {
        alert('Connect success');
        this.setState({isConnect: true});
      } else {
        alert('connect failed');
        this.setState({isConnect: false});
      }
    });
  };
  render() {
    if (this.state.isLoading) {
      return (
        <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
          <ActivityIndicator color={'blue'} />
        </View>
      );
    }
    if (this.state.isConnect) {
      return (
        <View style={{justifyContent: 'center', flex: 1, alignItems: 'center'}}>
          <Button title="Print!" color="#841584" onPress={this._startPrint} />
        </View>
      );
    }
    if (this.state.listPrinter.length > 0) {
      if (this.state.isOpenModal) {
        return (
          <ChoiceModal
            listData={this.state.listPrinter}
            modalVisible={this.state.isOpenModal}
            setModalVisible={this.setModalVisible}
          />
        );
      } else {
        return (
          <View
            style={{justifyContent: 'center', flex: 1, alignItems: 'center'}}>
            <Button
              title="Start Scan!"
              color="#841584"
              onPress={this._startScan}
            />
          </View>
        );
      }
    } else {
      return (
        <View style={{justifyContent: 'center', flex: 1, alignItems: 'center'}}>
          <Button
            title="Start Scan!"
            color="#841584"
            onPress={this._startScan}
          />
        </View>
      );
    }
  }
}

// const App = () => {
//   this.state = {
//     listPrinter: [],
//   };

//   const startScan = async () => {
//     await NativeModules.RNRongta.getDevicesList((error, listDevice) => {
//       if (error) {
//         alert(error)
//       } else {
//         this.setState({listPrinter: listDevice});
//       }

//     });
//   };

//   const getStatus = () => {
//     NativeModules.RNRongta.getStatus(response => {
//       alert(response);
//     });
//   };

//   const onPress = async () => {
//     //console.log('We will invoke the native module here!');
//     //NativeModules.RNRongta.printText('DEMO');

//     // NativeModules.RNRongta.startScan(response => {
//     //   alert(response);
//     // });

//     // NativeModules.RNRongta.getStatus(response => {
//     //   alert(response);
//     // });

//     //await NativeModules.RNRongta.startScan();
//     await NativeModules.RNRongta.getDevicesList(error => alert(error), res => alert(res));
//     //devices.map(device => alert(device));
//     //console.log(devices);
//   };

//   return (
//     <View style={{ justifyContent: 'center', flex: 1, alignItems: 'center' }}>
//       <Button
//         title="Start Scan!"
//         color="#841584"
//         onPress={startScan}
//       />
//     </View>
//   );
// };

export default App;
