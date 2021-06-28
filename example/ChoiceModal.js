import React, { Component } from 'react';
import {
  Text, TouchableHighlight, View,
  StyleSheet, Platform, FlatList, AppRegistry,
  TouchableOpacity, RefreshControl, Dimensions, TextInput, Modal, ListItem, Body
} from 'react-native';
// import { ListItem, Body } from "native-base";
// import { ListItem, Avatar } from 'react-native-elements'

export default class ChoiceModal extends Component {
  constructor(props) {
    super(props);
    this.state = {
      showModal: false,
    };
  }

  renderItem = (item, index) => {
    return (
      <View style={{marginTop:10}}>
                          <TouchableHighlight
                                onPress = {() => { this.props.setModalVisible(false, item, index) }}
                            >
                            <Text>{item.name}</Text>
                            </TouchableHighlight>
      </View>
    )
  };

  render() {
    return (
      <Modal
        animationType="slide"
        transparent={true}
        visible={this.state.modalVisible}
        onRequestClose={() => { this.props.setModalVisible(false) }}>
        <View style={{ justifyContent: 'center', flex: 1, alignItems: 'center' }}>
          <View style={{ width: 300, height: 300 }}>
            <FlatList
              data={this.props.listData}
              renderItem={({ item, index }) => this.renderItem(item, index)}
              keyExtractor={item => item.name}
            />
          </View>
        </View>
      </Modal>
    )
  }
}