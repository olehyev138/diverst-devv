/**
 *
 * LocaleToggle
 *
 */

import React from "react";
import PropTypes from "prop-types";

import Container from "react-bootstrap/Container";
import Row from "react-bootstrap/Row";
import Col from "react-bootstrap/Col";
import ToggleOption from "../ToggleOption";
import Select from "./Select";

function Toggle(props) {
    let content = <option>--</option>;

    // If we have items, render them
    if (props.values) {
        content = props.values.map(value => (
            <ToggleOption key={value} value={value} message={props.messages[value]} />
        ));
    }

    return (
        <Container>
            <Row>
                <Col xs={{ span: 6, offset: 5 }}>
                    <Select value={props.value} onChange={props.onToggle}>
                        {content}
                    </Select>
                </Col>
            </Row>
        </Container>
    );
}

Toggle.propTypes = {
    onToggle: PropTypes.func,
    values: PropTypes.array,
    value: PropTypes.string,
    messages: PropTypes.object,
};

export default Toggle;
