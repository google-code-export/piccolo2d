/*
 * Copyright (c) 2008-2009, Piccolo2D project, http://piccolo2d.org
 * Copyright (c) 1998-2008, University of Maryland
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided
 * that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 * and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions
 * and the following disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * None of the name of the University of Maryland, the name of the Piccolo2D project, or the names of its
 * contributors may be used to endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package edu.umd.cs.piccolo.util;

import java.awt.geom.Dimension2D;
import java.awt.geom.Point2D;
import java.io.Serializable;

/**
 * <b>PDimension</b> this class should be removed once a concrete Dimension2D
 * that supports doubles is added to java.
 * <P>
 * 
 * @version 1.0
 * @author Jesse Grosjean
 */
public class PDimension extends Dimension2D implements Serializable {
    /**
     * Allows for future serialization code to understand versioned binary
     * formats.
     */
    private static final long serialVersionUID = 1L;

    /** The width of the dimension. */
    public double width;

    /** The height of the dimension. */
    public double height;

    /**
     * Returns a dimension with no width or height.
     */
    public PDimension() {
        super();
    }

    /**
     * Copies the provided dimension.
     * 
     * @param aDimension dimension to copy
     */
    public PDimension(final Dimension2D aDimension) {
        this(aDimension.getWidth(), aDimension.getHeight());
    }

    /**
     * Creates a dimension with the provided dimensions.
     * 
     * @param aWidth desired width
     * @param aHeight desired height
     */
    public PDimension(final double aWidth, final double aHeight) {
        super();
        width = aWidth;
        height = aHeight;
    }

    /**
     * Creates a dimension that's the size of a rectangel with the points
     * provided as opposite corners.
     * 
     * @param p1 first point on rectangle
     * @param p2 point diagonally across from p1
     */
    public PDimension(final Point2D p1, final Point2D p2) {
        width = p2.getX() - p1.getX();
        height = p2.getY() - p1.getY();
    }

    /**
     * Returns the height of the dimension.
     * 
     * @return height height of the dimension
     */
    public double getHeight() {
        return height;
    }

    /**
     * Returns the width of the dimension.
     * 
     * @return width width of the dimension
     */
    public double getWidth() {
        return width;
    }

    /**
     * Resizes the dimension to have the dimensions provided.
     * 
     * @param aWidth desired width
     * @param aHeight desired height
     */
    public void setSize(final double aWidth, final double aHeight) {
        width = aWidth;
        height = aHeight;
    }

    /**
     * Returns a string representation of this dimension object.
     * 
     * @return string representation of this dimension object.
     */
    public String toString() {
        final StringBuffer result = new StringBuffer();

        result.append(super.toString().replaceAll(".*\\.", ""));
        result.append('[');
        result.append("width=");
        result.append(width);
        result.append(",height=");
        result.append(height);
        result.append(']');

        return result.toString();
    }
}
